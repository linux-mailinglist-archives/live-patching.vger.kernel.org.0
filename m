Return-Path: <live-patching+bounces-2145-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SKwcEjFOqmluPAEAu9opvQ
	(envelope-from <live-patching+bounces-2145-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 04:46:57 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A46AC21B4C5
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 04:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 83FC33014BC3
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 03:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DD536C0D3;
	Fri,  6 Mar 2026 03:43:39 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from 69-171-232-180.mail-mxout.facebook.com (69-171-232-180.mail-mxout.facebook.com [69.171.232.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C0336C0C5
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 03:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.171.232.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772768619; cv=none; b=tcF357GDzJjEKC70j3BLrRPyR/sdM7MoRKEDF46mxxP5H8AsHlwNNhQDEW4k8j2xDTX12jTLWbGN3KUPUUiz45dhVvacm4piMGU9seTpIesw+ee4cscdb6xGTO/EsNlt2adEr9D4vozkGtsxOSpHCoINkYNvLoCuS5bWFmx0D/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772768619; c=relaxed/simple;
	bh=XLF10N/BPmNrtU9Xp/CQSiynUMll3Pz+IJF3Ntemvbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O2AG5KjtsUm+caP30RxhDSuIMh0DLr6+xsz7Sxk3FRmpoXOfF5OzRJ9BUrxf+7iwM19nMvBwMREcNwS/VsjPMvtFJFDAxizUNpWWw519MX/WdHxT8RnrF9AHBD3nd1GdH0ZEHSK6ireBMtB+OecoPDYop55wPOlMqbO3rdBNEj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev; spf=fail smtp.mailfrom=linux.dev; arc=none smtp.client-ip=69.171.232.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=linux.dev
Received: by devvm16039.vll0.facebook.com (Postfix, from userid 128203)
	id 1A54A22BBCDDC; Thu,  5 Mar 2026 19:43:25 -0800 (PST)
From: Yonghong Song <yonghong.song@linux.dev>
To: linux-kbuild@vger.kernel.org,
	live-patching@vger.kernel.org
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
	kernel-team@fb.com,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Song Liu <song@kernel.org>
Subject: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes for clang thin-lto build
Date: Thu,  5 Mar 2026 19:43:25 -0800
Message-ID: <20260306034325.3605301-1-yonghong.song@linux.dev>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A46AC21B4C5
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.14 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[linux.dev : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.992];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_SEVEN(0.00)[7];
	R_DKIM_NA(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yonghong.song@linux.dev,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2145-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[]
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
function calls is 1212. Such symbols make kernel live patching
difficult since
  - a minor code change will change the hash and then the '*.llvm.<hash>'
    symbol becomes another one with a different hash or no hash, and
  - a previous source-level symbol may become an one with suffix after li=
ve
    patching code.

In [1], Song Liu suggested to reduce the number of '*.llvm.<hash>' functi=
ons
to make live patch easier. In respond of this, I implemented this
in llvm ([2]). The same thin-lto build with [2] only has two symbols with
suffix:
    m_stop.llvm.14460341347352036579
    m_next.llvm.14460341347352036579
This should make live patch much easier.

To support suffix symbol reduction, a new config
    LTO_CLANG_THIN_SUFFIX_REDUCTION
is introduced and the config depends on thin-lto and llvm23 or higher.

Two lld flags are necessary to enable this feature in kernel:
    - Flag '--lto-whole-program-visibility' is needed as it ensures that =
all
      modules are available in the same process, which is true for kernel=
 at
      thin-lto lld.
    - Flag '-mllvm -always-rename-promoted-locals=3Dfalse' is needed to e=
nable
      suffix reduction. Currently in llvm [1], only process mode is suppo=
rted.
      There is another distributed mode (across different processes or ev=
en
      different machines) which is not supported yet ([2]).

  [1] https://lpc.events/event/19/contributions/2212
  [2] https://github.com/llvm/llvm-project/pull/178587

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
---
 Makefile     |  3 +++
 arch/Kconfig | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/Makefile b/Makefile
index e944c6e71e81..9d6033595615 100644
--- a/Makefile
+++ b/Makefile
@@ -1034,6 +1034,9 @@ endif
 ifdef CONFIG_LTO_CLANG
 ifdef CONFIG_LTO_CLANG_THIN
 CC_FLAGS_LTO	:=3D -flto=3Dthin -fsplit-lto-unit
+ifdef CONFIG_LTO_CLANG_THIN_SUFFIX_REDUCTION
+KBUILD_LDFLAGS +=3D --lto-whole-program-visibility -mllvm -always-rename=
-promoted-locals=3Dfalse
+endif
 else
 CC_FLAGS_LTO	:=3D -flto
 endif
diff --git a/arch/Kconfig b/arch/Kconfig
index 102ddbd4298e..e1db64a3284e 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -861,8 +861,23 @@ config LTO_CLANG_THIN
 	    https://clang.llvm.org/docs/ThinLTO.html
=20
 	  If unsure, say Y.
+
 endchoice
=20
+config LTO_CLANG_THIN_SUFFIX_REDUCTION
+	bool "Clang ThinLTO Suffix Reduction (EXPERIMENTAL)"
+	depends on LTO_CLANG_THIN
+	depends on CLANG_VERSION >=3D 230000
+	default y
+	help
+	  This option allows to reduce the number of symbols with
+	  '.llvm.<hash' suffixes. This can help KLP (kernel living
+	  patch) as symbol name can stay stable in most cases.
+
+	  See https://github.com/llvm/llvm-project/pull/178587
+
+	  If unsure, say N.
+
 config ARCH_SUPPORTS_AUTOFDO_CLANG
 	bool
=20
--=20
2.47.3


