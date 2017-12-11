require "xcodeproj"

template_files = Dir.glob("./Sources/Stubber/*.erb")
project = Xcodeproj::Project.open("Stubber.xcodeproj")

# Add template file
source_group = project.groups
  .find { |group| group.name == "Sources" }.children
  .find { |group| group.name == "Stubber" }

for file in template_files
  filename = file.split("/")[-1]
  ref = source_group.new_reference(filename)
end

# Add run script
target = project.targets.find { |target| target.name == "Stubber" }
# phase = target.new_shell_script_build_phase("Generate Swift Code")
phase = project.new(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
phase.name = "Generate Swift Code"
phase.shell_script = "./scripts/gencode"
target.build_phases.insert(0, phase)

project.save
