(ns orestis
  (:require ["vscode" :as vscode]
            ["http" :as http]
            ["fs" :as fs]
            ["ext://betterthantomorrow.calva$v0" :as calva :refer [repl ranges]]
            [promesa.core :as p]
            [clojure.edn :as edn]
            [clojure.string :as string]
            [joyride.core :as joyride]
            ["path" :as path]))

;; Assuming this namespace i required by `activate.cljs`
;; you can reach vars in `my-lib` using `my-lib/<symbol>` in
;; `joyride.runCode` keybindings without requiring `my-lib``
;; there.

;; As an example, take the feature request on Calva to add a
;; **Restart clojure-lsp** command. It can be implemented with
;; with this function:
(defonce DEBUG (atom false))

(reset! DEBUG true)

(defn info [& xs]
  (vscode/window.showInformationMessage (string/join " " xs)))

(defn dprintln [& args]
  (when
   @DEBUG
    (let [out (joyride/output-channel)]
      (.show out true)
      (doseq [arg args]
        (.appendLine out arg)))))


(defn calva-evaluate
  ([code] (calva-evaluate code {}))
  ([code {:keys [session]}]
   (let [session (or session js/undefined)])
   (repl/evaluateCode session code)))

(defn make-http-req [options data cb]
  (let [req (.request http options
                      (fn [res]
                        (cb (.-statusCode res))
                        (when @DEBUG
                          (println "gr.orestis.workflow res" res (.-statusCode res))
                          (.on res "data" (fn [data]
                                            (println ">>>" data))))))]
    (.on req "error" (fn [error]
                       (println "gr.orestis.workflow error" error)))
    (when data
      (.write req data))
    (.end req)))


(defn read-portal-host-port []
  (let [edn (str (fs/readFileSync (path/join vscode/workspace.rootPath
                                             ".portal" "vs-code.edn")))
        {:keys [host port]} (clojure.edn/read-string edn)]
    {:host host :port port}))

(defn open-portal []
  (vscode/commands.executeCommand "extension.portalOpen"))

(defn ensure-portal-open []
  (let [path (path/join vscode/workspace.rootPath ".portal" "vs-code.edn")]
    (when-not (fs/existsSync path)
      (vscode/commands.executeCommand "extension.portalOpen"))))

(defn send-portal-value [{:keys [host port]} edn]
  (let [http-options #js {:hostname host
                          :port port
                          :method "POST"
                          :path "/submit"
                          :headers #js {"Content-Type" "application/edn"}}]

    (ensure-portal-open)
    (make-http-req http-options edn (fn [status-code]
                                      (if (= 204 status-code)
                                        (info "Portal:" (subs edn 0 10))
                                        (info "Portal err:" status-code))))
    edn))

(defn text-for-selection-command [selection-command-id]
  (let [_ (vscode/commands.executeCommand selection-command-id)
        selection vscode/window.activeTextEditor.selection
        document vscode/window.activeTextEditor.document
        code (.getText document selection)
        _ (vscode/commands.executeCommand "cursorUndo")]
    code))

(defn send-current-form-to-portal []
  (p/let [[_ text] (ranges/currentForm)
          result (calva-evaluate text)]
    (send-portal-value (read-portal-host-port) (.-result result))))

(defn send-toplevel-form-to-portal []
  (p/let [[_ text] (ranges/currentTopLevelForm)
          result (calva-evaluate text)]
    (send-portal-value (read-portal-host-port) (.-result result))))

(defn send-last-eval-to-portal []
  (p/let [result (calva-evaluate "*1")]
    (send-portal-value (read-portal-host-port) (.-result result))))

(defn restart-clojure-lsp []
  (p/do (vscode/commands.executeCommand "calva.clojureLsp.stop")
        (vscode/commands.executeCommand "calva.clojureLsp.start")))

(defn restart-nosco-system []
  (p/let [code (pr-str '(do
                          (require 'nosco.dev)
                          (in-ns 'nosco.dev)
                          (when nosco.main/SYSTEM
                            (component/stop-system nosco.main/SYSTEM))
                          (go)))
          result (calva-evaluate code)]

    (if (= ":ok" result)
      (info "Nosco System restarted")
      (info (str "Something went wrong: " result)))))

(defn connect-kourou []
  (vscode/commands.executeCommand "calva.connect"))

(def custom-commands
  #js [#js {:label "Send Last Eval to Portal" :fn send-last-eval-to-portal}
       #js {:label "Evaluate top-level form to Portal" :fn send-toplevel-form-to-portal}
       #js {:label "Evaluate current form to Portal" :fn send-current-form-to-portal}
       #js {:label "Restart Nosco System" :fn restart-nosco-system}
       #js {:label "Connect Kourou" :fn connect-kourou}
       #js {:label "Open Portal" :fn open-portal}
       #js {:label "Ensure Portal Open" :fn ensure-portal-open}
       #js {:label "Say Hi" :fn #(info "Hi!")}])


(defn show-my-commands []
  (p/let [command (vscode/window.showQuickPick
                   custom-commands
                   #js{:title "Select a custom command"})]
    (when command
      ((.-fn command)))))

(def status-bar-item (vscode/window.createStatusBarItem
                      "orestis-status-bar"
                      vscode/StatusBarAlignment.Right
                      1000))



(set! (.-text status-bar-item) "OM")
(set! (.-tooltip status-bar-item) "ctrl-cmd-P <space>")
(set! (.-command status-bar-item)
      #js {:command "joyride.runCode"
           :arguments #js ["(orestis/show-my-commands)"]})
(.show status-bar-item)


;; And then this shortcut definition in `keybindings.json`
;; {
;;     "key": "<some-keyboard-shortcut>",
;;     "command": "joyride.runCode",
;;     "args": "(my-lib/restart-clojure-lsp)"
;; },

;; If you get complaints about `my-lib` not found, you probably
;; have not required it from `activate.cljs`