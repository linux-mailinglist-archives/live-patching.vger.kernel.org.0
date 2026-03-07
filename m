Return-Path: <live-patching+bounces-2158-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OXM/GJGxq2mSfgEAu9opvQ
	(envelope-from <live-patching+bounces-2158-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 07 Mar 2026 06:03:13 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E40EF22A2CE
	for <lists+live-patching@lfdr.de>; Sat, 07 Mar 2026 06:03:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1D138300D353
	for <lists+live-patching@lfdr.de>; Sat,  7 Mar 2026 05:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8916837475A;
	Sat,  7 Mar 2026 05:03:10 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC24B374194
	for <live-patching@vger.kernel.org>; Sat,  7 Mar 2026 05:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.220.155.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772859790; cv=none; b=eTTRjHNPCjbEIhZGhWWIyJ8BDRHj8zIGgSkZiruIJrHBh8EXyOq90E2032Jba/gfh+O4x6F/7f/OESel1YlRTYyDdVog77LAQqG8Gfr7gxOGUTd9wO7nsAUdIuanVdrUBz1hfx777PBpRy8lIfbbF7YbIC0t3p0ZnNBF0SFQ9zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772859790; c=relaxed/simple;
	bh=BCilRAeNJWU02FKj/jAnUXtLJ5HWuqJsljI+QH4QRJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hLhK+F65pOcnzUov7suHxX8Jm8+dbos8+PzURxon9nP3NglE7OBaAxBsvA7d6UB3luas90fKeXwF59/Ei8y6D3/nxKAaiZYIOggWzqJ5vQhjwhPaVkaIsWXaPHcVmm6+i3ecTa5jxLptAaPkMoEQKKYjTfLFv7ZJPj5AVjyHgEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev; spf=fail smtp.mailfrom=linux.dev; arc=none smtp.client-ip=66.220.155.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linux.dev
Received: by devvm16039.vll0.facebook.com (Postfix, from userid 128203)
	id 8892E23472305; Fri,  6 Mar 2026 21:02:50 -0800 (PST)
From: Yonghong Song <yonghong.song@linux.dev>
To: linux-kbuild@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	kernel-team@fb.com,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Song Liu <song@kernel.org>
Subject: [PATCH kbuild v2] kbuild: Reduce the number of compiler-generated suffixes for clang thin-lto build
Date: Fri,  6 Mar 2026 21:02:50 -0800
Message-ID: <20260307050250.3767489-1-yonghong.song@linux.dev>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E40EF22A2CE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[linux.dev : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2158-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[yonghong.song@linux.dev,live-patching@vger.kernel.org];
	R_DKIM_NA(0.00)[];
	NEURAL_HAM(-0.00)[-0.425];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,linux.dev:mid,linux.dev:email,lpc.events:url]
X-Rspamd-Action: no action

The current clang thin-lto build often produces lots of symbols with
suffix. The following is a partial list of such function call symbols:
    ...
    ethnl_module_fw_flash_ntf.llvm.7631589765585346066
    __nf_conntrack_alloc.llvm.6438426151906658917
    tcp_can_early_drop.llvm.11937612064648250727
    tcp_print_conntrack.llvm.11937612064648250727
    ...

In my particular build with current bpf-next, the number of '*.llvm.<hash=
>'
function calls is 1212. As the side effect of cross-file inlining,
some static variables may be promoted with '*.llvm.<hash>' as well.
In my same setup, the number of variables with such suffixes is 9.

Such symbols make kernel live patching difficult since
  - a minor code change will change the hash and then the '*.llvm.<hash>'
    symbol becomes another one with a different hash. Sometimes, maybe
    the suffix is gone.
  - a previous source-level symbol may become a one with suffix after liv=
e
    patching code.

In [1], Song Liu suggested to reduce the number of '*.llvm.<hash>' functi=
ons
to make live patch easier. In respond of this, I implemented this
in llvm ([2]). The same thin-lto build with [2] only has two symbols with
suffix:
    m_stop.llvm.14460341347352036579
    m_next.llvm.14460341347352036579
This should make live patch much easier.

To support suffix symbol reduction, two lld flags are necessary to enable
this feature in kernel:
    - Flag '--lto-whole-program-visibility' is needed as it ensures that =
all
      non-assembly files are available in the same thin-lto lld, which is=
 true
      for kernel.
    - Flag '-mllvm -always-rename-promoted-locals=3Dfalse' is needed to e=
nable
      suffix reduction. Currently in llvm [1], only process mode is suppo=
rted.
      There is another distributed mode (across different processes or ev=
en
      different machines) which is not supported yet ([2]). The kernel us=
es
      process mode so it should work.

The assembly files may have some global functions/data which may potentia=
lly
conflict with thin-lto global symbols after the above two flags. But such=
 assembly
global symbols are limited and tend to be uniquely named for its context.
Hence the conflict with globals in non-assembly codes is rare. If indeed =
the
conflict happens, we can rename either of them to avoid conflicts.

Nathan Chancellor suggested the following under thin-lto:
  KBUILD_LDFLAGS +=3D $(call ld-option,--lto-whole-program-visibility -ml=
lvm -always-rename-promoted-locals=3Dfalse)
The '-mllvm -always-rename-promoted-locals=3Dfalse' flag is only availabl=
e for llvm23.
So for llvm22 or earlier, the above KBUILD_LDFLAGS will ignore those two =
flags.
For llvm23 and later, two flags will be added to KBUILD_LDFLAGS.

  [1] https://lpc.events/event/19/contributions/2212
  [2] https://github.com/llvm/llvm-project/pull/178587

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

Changelog:
  v1 -> v2:
    - v1: https://lore.kernel.org/linux-kbuild/20260306034325.3605301-1-y=
onghong.song@linux.dev/
    - Removed the new config option and use ld-option to check whether ne=
w flags
      will be used or not.

diff --git a/Makefile b/Makefile
index e944c6e71e81..e4385af16985 100644
--- a/Makefile
+++ b/Makefile
@@ -1034,6 +1034,7 @@ endif
 ifdef CONFIG_LTO_CLANG
 ifdef CONFIG_LTO_CLANG_THIN
 CC_FLAGS_LTO	:=3D -flto=3Dthin -fsplit-lto-unit
+KBUILD_LDFLAGS +=3D $(call ld-option,--lto-whole-program-visibility -mll=
vm -always-rename-promoted-locals=3Dfalse)
 else
 CC_FLAGS_LTO	:=3D -flto
 endif
--=20
2.47.3


