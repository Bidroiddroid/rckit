# Components

Components are registered in `config/manifest.yaml`.

To add a component:

1. Create `modules/<component>/module.sh`.
2. Implement `detect`, `install`, `configure`, `verify`, `update`, `remove`, and `doctor` through the standard module contract.
3. Register the component in `config/manifest.yaml`.
4. Add it to profiles only when it is a useful default for that profile.
5. Add tests for dependency resolution and lifecycle behavior.
