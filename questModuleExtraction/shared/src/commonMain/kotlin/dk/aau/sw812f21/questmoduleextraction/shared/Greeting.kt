package dk.aau.sw812f21.questmoduleextraction.shared


class Greeting {
    fun greeting(): String {
        return "Hello, ${Platform().platform}!"
    }
}
