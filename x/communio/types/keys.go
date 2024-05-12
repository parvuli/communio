package types

const (
	// ModuleName defines the module name
	ModuleName = "communio"

	// StoreKey defines the primary module store key
	StoreKey = ModuleName

	// MemStoreKey defines the in-memory store key
	MemStoreKey = "mem_communio"
)

var (
	ParamsKey = []byte("p_communio")
)

func KeyPrefix(p string) []byte {
	return []byte(p)
}
