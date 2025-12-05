Return-Path: <live-patching+bounces-1900-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EF37CA61B1
	for <lists+live-patching@lfdr.de>; Fri, 05 Dec 2025 05:34:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id D5D3C3012C8C
	for <lists+live-patching@lfdr.de>; Fri,  5 Dec 2025 04:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01592DAFBA;
	Fri,  5 Dec 2025 04:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eXV9kLEu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBF4261B8C;
	Fri,  5 Dec 2025 04:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764909258; cv=none; b=SSpl1mU1i1gE3bjbDBSphDFdhfZqaEPelZkbD47cWdbIiIh37NW+/OouXEehZN0r0hRvIe8Z58UYP3HVPsD7zWYQdYbInenTwyencuvUGRwobMB8nY/9T0APZZ/mVZibHINKf8ZWdpjfSF4bh4RNH7ydNma3FWYIwDf16DVzGxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764909258; c=relaxed/simple;
	bh=BTTO7S67pYrc+iPyi8vMbS7klQBdOJREUyOK/N4z6iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oh0p1/gxs7Tlq9EZghewmLQ/+RsnpOblU0msc/tgz5L2OQzC+BIbBag+7jGKrXROwJoeZ9ByXlH0PLr6qkJp/LBb79xyP51Yy5r24Y/pA9WqACxzWSo2TtU1wUSZH+dPtVczjrCjmhghXCegCwcU1/MwfQ3kQgFmUcHxZA1MXO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eXV9kLEu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614CBC4CEF1;
	Fri,  5 Dec 2025 04:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764909258;
	bh=BTTO7S67pYrc+iPyi8vMbS7klQBdOJREUyOK/N4z6iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eXV9kLEuRIotvwDvo5BcIaPnh/Ofrm1+uo2fArb9bZlSvbLv1evwW93z3CTC09N70
	 XhtoTb14v0vSBdjdXxDntmnN0TyYHqf3198pUlLnVUXmCAg4jE/EVk83d22stwH7ki
	 DN1uW5LycFw3dFAa1bRjc3Qh8R8LE4bPA1RfaBfM+xj3VXiv+qY+HOJqrl6vBpQ+88
	 Bdu31kYYr2x9rsNv+aL8Fep7q8KlYB4no5H6GBWT5NvDzxU8TLv6zpQA8Nf6UcysWX
	 dDLhfeBZWr8mJg1Ra0KTtB3lCtk7512Nxm6pnWA2HHi042eFFJi0XkA10/eehsoSwr
	 dN5qN89PTY/kg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Song Liu <song@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	jikos@kernel.org,
	mbenes@suse.cz,
	live-patching@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] livepatch: Match old_sympos 0 and 1 in klp_find_func()
Date: Thu,  4 Dec 2025 23:33:44 -0500
Message-ID: <20251205043401.528993-3-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251205043401.528993-1-sashal@kernel.org>
References: <20251205043401.528993-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Liu <song@kernel.org>

[ Upstream commit 139560e8b973402140cafeb68c656c1374bd4c20 ]

When there is only one function of the same name, old_sympos of 0 and 1
are logically identical. Match them in klp_find_func().

This is to avoid a corner case with different toolchain behavior.

In this specific issue, two versions of kpatch-build were used to
build livepatch for the same kernel. One assigns old_sympos == 0 for
unique local functions, the other assigns old_sympos == 1 for unique
local functions. Both versions work fine by themselves. (PS: This
behavior change was introduced in a downstream version of kpatch-build.
This change does not exist in upstream kpatch-build.)

However, during livepatch upgrade (with the replace flag set) from a
patch built with one version of kpatch-build to the same fix built with
the other version of kpatch-build, livepatching fails with errors like:

[   14.218706] sysfs: cannot create duplicate filename 'xxx/somefunc,1'
...
[   14.219466] Call Trace:
[   14.219468]  <TASK>
[   14.219469]  dump_stack_lvl+0x47/0x60
[   14.219474]  sysfs_warn_dup.cold+0x17/0x27
[   14.219476]  sysfs_create_dir_ns+0x95/0xb0
[   14.219479]  kobject_add_internal+0x9e/0x260
[   14.219483]  kobject_add+0x68/0x80
[   14.219485]  ? kstrdup+0x3c/0xa0
[   14.219486]  klp_enable_patch+0x320/0x830
[   14.219488]  patch_init+0x443/0x1000 [ccc_0_6]
[   14.219491]  ? 0xffffffffa05eb000
[   14.219492]  do_one_initcall+0x2e/0x190
[   14.219494]  do_init_module+0x67/0x270
[   14.219496]  init_module_from_file+0x75/0xa0
[   14.219499]  idempotent_init_module+0x15a/0x240
[   14.219501]  __x64_sys_finit_module+0x61/0xc0
[   14.219503]  do_syscall_64+0x5b/0x160
[   14.219505]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[   14.219507] RIP: 0033:0x7f545a4bd96d
...
[   14.219516] kobject: kobject_add_internal failed for somefunc,1 with
    -EEXIST, don't try to register things with the same name ...

This happens because klp_find_func() thinks somefunc with old_sympos==0
is not the same as somefunc with old_sympos==1, and klp_add_object_nops
adds another xxx/func,1 to the list of functions to patch.

Signed-off-by: Song Liu <song@kernel.org>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
[pmladek@suse.com: Fixed some typos.]
Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `livepatch: Match old_sympos 0 and 1 in klp_find_func()`

**Key indicators:**
- Fixes a bug: livepatch upgrade failures with replace flag
- Real-world impact: sysfs duplicate filename error causing patch
  enablement to fail
- Clear problem description with error logs
- Tested-by: Petr Mladek
- Reviewed-by: Petr Mladek, Josh Poimboeuf

**Root cause:** Different versions of kpatch-build assign `old_sympos` 0
vs 1 for unique functions. During livepatch upgrade with replace,
`klp_find_func()` doesn't match them, leading to duplicate sysfs
entries.

### 2. CODE CHANGE ANALYSIS

**Files changed:** 1 file (`kernel/livepatch/core.c`)
**Lines changed:** 7 lines added, 1 line modified

**Change:**
```c
// Before:
if ((strcmp(old_func->old_name, func->old_name) == 0) &&
    (old_func->old_sympos == func->old_sympos)) {

// After:
if ((strcmp(old_func->old_name, func->old_name) == 0) &&
    ((old_func->old_sympos == func->old_sympos) ||
     (old_func->old_sympos == 0 && func->old_sympos == 1) ||
     (old_func->old_sympos == 1 && func->old_sympos == 0))) {
```

**Technical explanation:**
- For unique symbols, `old_sympos` 0 and 1 both refer to the first
  occurrence
- `klp_find_object_symbol()` treats `sympos == 0` as "unique symbol"
  (see lines 170-175)
- Sysfs displays `old_sympos == 0` as `1` (line 820: `func->old_sympos ?
  func->old_sympos : 1`)
- The fix makes `klp_find_func()` treat 0 and 1 as equivalent for
  matching

**Why this fixes the bug:**
- During replace upgrade, `klp_add_object_nops()` calls
  `klp_find_func()` to check if a function already exists
- Without the fix, `old_sympos==0` and `old_sympos==1` don't match
- This causes duplicate sysfs entries, leading to `-EEXIST` and patch
  enablement failure

### 3. CLASSIFICATION

**Type:** Bug fix (not a feature)

**Exception categories:** None needed — this is a bug fix

**Security:** No security impact, but prevents a reliability issue

### 4. SCOPE AND RISK ASSESSMENT

**Scope:**
- Single function (`klp_find_func()`)
- Localized change
- No architectural changes

**Risk:** Low
- Small, targeted change
- Clear logic
- No new code paths
- Only affects matching logic for unique symbols

**Potential issues:**
- None identified
- Change is conservative (adds equivalence, doesn't remove checks)

### 5. USER IMPACT

**Severity:** High for affected users
- Prevents livepatch upgrades with replace flag
- Causes kernel errors and patch enablement failure
- Affects users upgrading between different kpatch-build versions

**Affected users:**
- Users performing livepatch upgrades with replace
- Users mixing kpatch-build versions
- Enterprise users relying on livepatch for updates

**Impact assessment:**
- Core livepatch functionality (upgrade path)
- Real-world scenario (different toolchain versions)
- User-visible failure (error messages, failed upgrades)

### 6. STABILITY INDICATORS

**Testing:**
- Tested-by: Petr Mladek
- Reviewed-by: Petr Mladek, Josh Poimboeuf
- Real-world scenario documented

**Code maturity:**
- Function exists since atomic replace (Jan 2019)
- Present in stable trees (5.1+)
- Mature code path

### 7. DEPENDENCY CHECK

**Dependencies:**
1. `klp_find_func()` — introduced with atomic replace (commit
   e1452b607c48c, Jan 2019)
2. `klp_add_object_nops()` — same commit
3. Replace functionality — present since ~5.1

**Backport compatibility:**
- Applies cleanly to any stable tree with atomic replace
- No other commits required
- Self-contained fix

**Affected stable versions:**
- Any stable tree with atomic replace (~5.1+)
- All current LTS trees (6.1.y, 6.6.y, etc.)

### 8. STABLE KERNEL RULES COMPLIANCE

**Meets criteria:**
1. Obviously correct: Yes — clear equivalence for unique symbols
2. Fixes real bug: Yes — documented failure case
3. Important issue: Yes — breaks livepatch upgrades
4. Small and contained: Yes — 7 lines, 1 function
5. No new features: Yes — bug fix only
6. Applies cleanly: Yes — no conflicts expected

**No violations:**
- No new features
- No API changes
- No architectural changes
- No new dependencies

### 9. RISK VS BENEFIT TRADE-OFF

**Benefit:**
- Fixes upgrade failures
- Low risk, high value
- Addresses real user issue

**Risk:**
- Minimal — localized change
- Conservative logic
- Well-tested

**Conclusion:** Strong benefit, minimal risk

### 10. FINAL ASSESSMENT

This commit should be backported to stable kernel trees.

**Reasons:**
1. Fixes a real bug that breaks livepatch upgrades
2. Small, localized change (7 lines)
3. Low risk, clear logic
4. Well-tested and reviewed
5. No new features or dependencies
6. Applies cleanly to stable trees with atomic replace
7. High user impact for affected users

**Recommendation:** Backport to all stable trees that include atomic
replace functionality (approximately 5.1.y and later).

**YES**

 kernel/livepatch/core.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0e73fac55f8eb..4e7a5cbc40a91 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -88,8 +88,14 @@ static struct klp_func *klp_find_func(struct klp_object *obj,
 	struct klp_func *func;
 
 	klp_for_each_func(obj, func) {
+		/*
+		 * Besides identical old_sympos, also consider old_sympos
+		 * of 0 and 1 are identical.
+		 */
 		if ((strcmp(old_func->old_name, func->old_name) == 0) &&
-		    (old_func->old_sympos == func->old_sympos)) {
+		    ((old_func->old_sympos == func->old_sympos) ||
+		     (old_func->old_sympos == 0 && func->old_sympos == 1) ||
+		     (old_func->old_sympos == 1 && func->old_sympos == 0))) {
 			return func;
 		}
 	}
-- 
2.51.0


