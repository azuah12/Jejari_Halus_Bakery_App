# Jejari_Halus_Bakery_App
## How we work

- No one commits straight to `main`. Every change goes on a branch and is merged through a Pull Request (PR).
- Every PR needs at least 1 approval from a teammate before it is merged.
- Each task is a GitHub Issue with an owner, a reviewer and its requirement ID (FR-xx).
- Name branches like `feature/fr-07-payment` or `chore/update-logai`.
- Commit messages are short and say what changed, for example `Add payment receipt upload (FR-07)`.
- Never commit API keys, passwords or client data.
- Update LOGAI whenever AI is used for significant work, and LOGTEST for every formal test run.
- Process forms (LOGAI, LOGT, LOGTEST, LOGD, WEEK) are kept in `process_forms/`.
