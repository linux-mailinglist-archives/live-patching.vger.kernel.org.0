Return-Path: <live-patching+bounces-1068-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 568E6A1FFE3
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 22:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F0AD18877BD
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 21:33:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAE2C1D90A9;
	Mon, 27 Jan 2025 21:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LsUVDCqj"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479931D7E52
	for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 21:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738013605; cv=none; b=uDOnPKXvo1Tphp8stgWm91XiULkppBRIYaAu9vp40nyk72bQqYcQUGlt/P1sOuzy1jCr72MZqMNClpXIvscWCc/oo6toJv89YnTBAAQfDCUiV5lheWhp/bv6GZDO0GjodQsyk3o2MbtDdx0vq+xwlq8UVaN/KTD8CyaWkCOhCBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738013605; c=relaxed/simple;
	bh=YMGY+TCeN92CwabsHBMERr0zATeblJzChZgSnquU71c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cAZvWGTOipBSzT7WNGXOo1SVHdb2mSZqOo4OIeM555tdzIN/TwRCsxA+s1S4/vAvfSC1F42p37zPZ76nmLOf8GEz/6RQxStn3hmZFvntVcSppFLg5VO3oXxOD647wR+fC3O8RzIPardLPMBV0nr8dLD4YTfM/pPiekEAmK5ZBAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LsUVDCqj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-21650d4612eso132660675ad.2
        for <live-patching@vger.kernel.org>; Mon, 27 Jan 2025 13:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738013603; x=1738618403; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pMhIr+En9Z5bHr+SI41rtrYzgjvtxfxDwtbSrjCCifE=;
        b=LsUVDCqjVA4yITRHQUBA+6G/hZwJo54QmwvOtNpExkCk52PK3Tdls+KQ/xGgnldWWa
         6RwBIaxEFbS48ZAeKoo0vrdjdPlkQzi5ODJiLfFXc+YX5aYeoNjBldCeMXvl31P0eX84
         42KHf5D82hJwfeitLYRjgYVkHUP44qUdIWgsVNjUysi0sJnZt13nuhSD68KnNvr2i77f
         WEWuC+h+sorx79bzx9yQHO5W5IFNRK1q1eaeQlbRytansIKued7sfevbwTD+L2Yj9hqa
         919MJGazrlUuufA89Bw7BarJtq4wgARTedgrS2yi1FKeX2uSYTBrq9EF7UN8WCVFUkP9
         kbhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738013603; x=1738618403;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pMhIr+En9Z5bHr+SI41rtrYzgjvtxfxDwtbSrjCCifE=;
        b=Q/YscvnHVjTYHMeoc7PAegXx+GBc0fVhzeoe+Qm/jAAb68HPnNr6/7KMbT6PEdOZKp
         wBX6kBiXoV8QHjxEEmLrwwo/XFQD176ADLioj0wwj1Dg2+OxfvvGQmXrPsxc0ETyXygB
         TIhmgRiQeQ1poAgOGT7VCcqCGFDNp078JQ2h6ASOthQg5AtGyc6SdUIUqDieiEINM+H6
         Zd/l46UMoHhuMvPWDhlZ5mtaiDHivBhJ3rmEPNXwTuNWURDB6bhRqXFT63F0CfTDWwPg
         Jh8ZrBlopQtdAq/YkZYpmJpy/F/SyWWALWH0+nbopk4kWagXaDHhKpKS+vLvXyvfircQ
         7Rvw==
X-Forwarded-Encrypted: i=1; AJvYcCVNjtWBS7cDML1k1qTALrYpjXEP+V9Zue2I3a389jjJ5bP5/oNW7Lm3YuiC8sTVVnLb88I3ZzoT+WKBaAuP@vger.kernel.org
X-Gm-Message-State: AOJu0YwysgwRjwW35drWBK1EFqborkm27Q6pvA45BoBK2UtcRvJ2D9rJ
	iyqeEKszM1HQjx8GXBfoe2wuHVs9pvF4dJCqAN/Zt7JEVzmYnHmKNP6k/U+XXdfQQJZAjNFxWg=
	=
X-Google-Smtp-Source: AGHT+IFf6J6rV9/t9kV/JQeXUvSzBEZruRhcKXoKcnyF96aSdB43mkOwhOGscpzW9zOTOb0X7BG/2BEB9g==
X-Received: from pfbjc33.prod.google.com ([2002:a05:6a00:6ca1:b0:728:b3dd:ba8c])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:430d:b0:1e1:aef4:9ce7
 with SMTP id adf61e73a8af0-1eb214a08b6mr60696359637.17.1738013603568; Mon, 27
 Jan 2025 13:33:23 -0800 (PST)
Date: Mon, 27 Jan 2025 21:33:03 +0000
In-Reply-To: <20250127213310.2496133-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250127213310.2496133-1-wnliu@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127213310.2496133-2-wnliu@google.com>
Subject: [PATCH 1/8] unwind: build kernel with sframe info
From: Weinan Liu <wnliu@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org, 
	Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

Use the -Wa,--gsframe flags to build the code, so GAS will generate
a new .sframe section for the stack trace information.
Currently, the sframe format only supports arm64 and x86_64
architectures. Add this configuration on arm64 to enable sframe
unwinder in the future.

Signed-off-by: Weinan Liu <wnliu@google.com>
---
 Makefile                          |  6 ++++++
 arch/Kconfig                      |  8 ++++++++
 arch/arm64/Kconfig.debug          | 10 ++++++++++
 include/asm-generic/vmlinux.lds.h | 12 ++++++++++++
 4 files changed, 36 insertions(+)

diff --git a/Makefile b/Makefile
index b9464c88ac72..35200c39b98d 100644
--- a/Makefile
+++ b/Makefile
@@ -1064,6 +1064,12 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS   += -fconserve-stack
 endif
 
+# build with sframe table
+ifdef CONFIG_SFRAME_UNWIND_TABLE
+KBUILD_CFLAGS	+= -Wa,--gsframe
+KBUILD_AFLAGS	+= -Wa,--gsframe
+endif
+
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)
diff --git a/arch/Kconfig b/arch/Kconfig
index 6682b2a53e34..ae70f7dbe326 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1736,4 +1736,12 @@ config ARCH_WANTS_PRE_LINK_VMLINUX
 	  An architecture can select this if it provides arch/<arch>/tools/Makefile
 	  with .arch.vmlinux.o target to be linked into vmlinux.
 
+config AS_HAS_SFRAME_SUPPORT
+	# Detect availability of the AS option -Wa,--gsframe for generating
+	# sframe unwind table.
+	def_bool $(cc-option,-Wa$(comma)--gsframe)
+
+config SFRAME_UNWIND_TABLE
+	bool
+
 endmenu
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 265c4461031f..ed619fcb18b3 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -20,4 +20,14 @@ config ARM64_RELOC_TEST
 	depends on m
 	tristate "Relocation testing module"
 
+config SFRAME_UNWINDER
+	bool "Sframe unwinder"
+	depends on AS_HAS_SFRAME_SUPPORT
+	depends on 64BIT
+	select SFRAME_UNWIND_TABLE
+	help
+	  This option enables the sframe (Simple Frame) unwinder for unwinding
+	  kernel stack traces. It uses unwind table that is direclty generated
+	  by toolchain based on DWARF CFI information
+
 source "drivers/hwtracing/coresight/Kconfig"
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 54504013c749..6a437bd084c7 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -469,6 +469,8 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 		*(.rodata1)						\
 	}								\
 									\
+	SFRAME								\
+									\
 	/* PCI quirks */						\
 	.pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {	\
 		BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_early,  __start, __end) \
@@ -886,6 +888,16 @@ defined(CONFIG_AUTOFDO_CLANG) || defined(CONFIG_PROPELLER_CLANG)
 #define TRACEDATA
 #endif
 
+#ifdef CONFIG_SFRAME_UNWIND_TABLE
+#define SFRAME							\
+	/* sframe */						\
+	.sframe        : AT(ADDR(.sframe) - LOAD_OFFSET) {	\
+		BOUNDED_SECTION_BY(.sframe, _sframe_header)	\
+	}
+#else
+#define SFRAME
+#endif
+
 #ifdef CONFIG_PRINTK_INDEX
 #define PRINTK_INDEX							\
 	.printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {		\
-- 
2.48.1.262.g85cc9f2d1e-goog


