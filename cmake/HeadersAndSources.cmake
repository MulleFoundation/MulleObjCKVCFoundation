#
# The following includes include definitions generated
# during `mulle-sde update`. Don't edit those files. They are
# overwritten frequently.
#
# === MULLE-SDE START ===

include( _Headers)
include( _Sources)

# === MULLE-SDE END ===
#

# add ignored headers back in
set( PUBLIC_HEADERS
"src/_MulleObjCKVCFoundation-import.h"
"src/_MulleObjCKVCFoundation-include.h"
${PUBLIC_HEADERS}
)

set( PRIVATE_HEADERS
"src/_MulleObjCKVCFoundation-import-private.h"
"src/_MulleObjCKVCFoundation-include-private.h"
${PRIVATE_HEADERS}
)

#
# You can put more source and resource file definitions here.
#
