Return-Path: <live-patching+bounces-1627-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A24BB449D0
	for <lists+live-patching@lfdr.de>; Fri,  5 Sep 2025 00:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA05318873A0
	for <lists+live-patching@lfdr.de>; Thu,  4 Sep 2025 22:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DBA32EF643;
	Thu,  4 Sep 2025 22:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3+mP/jxQ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980622ED869
	for <live-patching@vger.kernel.org>; Thu,  4 Sep 2025 22:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757025563; cv=none; b=p4n3UuYKUJ/H/dkw3WA7uI1QDpUW0oTOQoP102ms0yy1yNXlVAAnOYC1GlYbHr+KuPvk49tdIlGzxVzAaRjxUrbuiKKdtZGTWNdkTgZh0XA21hpNfRCJHtUMs20Ri2iXJLfX1nU+hqzHDqtiCkTlOio/e8o/cOiRe0xqZAmTL/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757025563; c=relaxed/simple;
	bh=NovLOGBdyArFTxtU+57EVnKh/sjgYEL5oQ0KRAhMNk8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ohDvH8lakgLc4vZduj7Jnx6ttxMZJZ8YnNQllo7w0kSqgfoZdTsQ0E6lvHx74HRBXv3hIesrB7W3pYhzKb9AlcUtbEy75YfdiqMgrbek21rvJiH699x8w2gEhQLYva+AG3J5ZGvGLi8e3D/7VoA0v2e9k2oVl+lqa6FlUi8XQ/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3+mP/jxQ; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32bbe7c5b87so285174a91.3
        for <live-patching@vger.kernel.org>; Thu, 04 Sep 2025 15:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757025561; x=1757630361; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2m08r/ZQjtbTIB1gTP1Sld7JP5u72ORtVv9DJEb0tSQ=;
        b=3+mP/jxQ0ziCoP9Ai1chQHA6UMMd5teHT6Uqo12P1qQPcKbx2JHSORrMDmISmM3D27
         7I7ar/02FXtPV7gLQyH6ADtcxco6Rgqocku51fmsRr0H+FLYVUl+KZdU2DkCL4zJc7KS
         MBhW9NAPi7leJl5fTywmfDSRqA/2EzcLUIyKQX/jxbVMjeAUNh05F3dcilyXm56hwjZv
         /5r1ewuEe95hrHBG6Fa5WaFKzBAVyrV7C69wFVmtPXvBDq+UJI2M7FBKKCXDngqueWMk
         2manxpxiOtbqkdy3Hb+enQvA3oVp29cnEfONL1Ni26m88HzlOvF4HDHtq4cTqByYRNTg
         8WAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757025561; x=1757630361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2m08r/ZQjtbTIB1gTP1Sld7JP5u72ORtVv9DJEb0tSQ=;
        b=eRdy59jU7+x96PLjAo3A3yD/DdJ27N2C4SlfxPXcrD7boiXg+ZOHuuF4w1aN/viTx/
         P0aZi935OzlRcEBw9ppQNmBUMbTWOpQQM63QC2Ep4LV3Z6nOSKj5SwJfSqMNX0DPF2kh
         gv2pTlD+dG3PxGMe6IWKL2zD+/z+BN/H7pBtqx/nFdGS2gXvoPDvotS/H3/GmH0C5eKS
         9NngCmLLJRf7KzhQ6clZ9WF9sl1CDPKSjQSJ7Kn+hwwUy1io40rD0WX912iOV7xzm82m
         Yi4fsDqX2+9LpWrJlzfeBtHexnSYatBDYpZrnTI/HUgcNm4YCvNaEn9m8+u+nTFcoI6L
         zstw==
X-Forwarded-Encrypted: i=1; AJvYcCViWezDohgnckutKAUVmWyJ4snxmKxfz92kmGnJJEB68WEkqdXHULuU3q9hfSEF4hNgATRMlU7uwZdPVSqc@vger.kernel.org
X-Gm-Message-State: AOJu0YzEPkOj7Is5XtzJkkhquIPJGoOqcFJvvIGcJ5yTyzR5rlm5B3kx
	eVBH293s6DzbYeNDU40tI5OBxBmNROm8vZO8Fn3pGjKtWbvNmk9O0q/Iux4oMeyROD22ypJHuEI
	7Pfxs++A8Tcbg/YEfjFapkkSZ7g==
X-Google-Smtp-Source: AGHT+IEydTUhEuAQ3A1H8zKyclA89jCNB3VUkBozS1oBCNaZG2tV6zRAiEaoyka9mctrU/XAtHk0Qslbb13/nP1pWg==
X-Received: from pjbsx14.prod.google.com ([2002:a17:90b:2cce:b0:32b:682f:e6ca])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1d03:b0:320:fda8:fabe with SMTP id 98e67ed59e1d1-328156ba3b0mr23030730a91.22.1757025561033;
 Thu, 04 Sep 2025 15:39:21 -0700 (PDT)
Date: Thu,  4 Sep 2025 22:38:47 +0000
In-Reply-To: <20250904223850.884188-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250904223850.884188-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.51.0.355.g5224444f11-goog
Message-ID: <20250904223850.884188-4-dylanbhatch@google.com>
Subject: [PATCH v2 3/6] unwind: add sframe v2 header
From: Dylan Hatch <dylanbhatch@google.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian Rogers <irogers@google.com>, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, joe.lawrence@redhat.com, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Add sframe header so that we know how to access the sframe section
generated by compilers.

This is the sframe header file borrowed from the patchset [1]
Josh Poimboeuf according to sframe v2 spec [2].

[1]: https://lore.kernel.org/all/f27e8463783febfa0dabb0432a3dd6be8ad98412.1737511963.git.jpoimboe@kernel.org/
[2]: https://sourceware.org/binutils/docs/sframe-spec.html

Signed-off-by: Weinan Liu <wnliu@google.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
Reviewed-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
---
 kernel/sframe.h | 75 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)
 create mode 100644 kernel/sframe.h

diff --git a/kernel/sframe.h b/kernel/sframe.h
new file mode 100644
index 000000000000..e9045f980fee
--- /dev/null
+++ b/kernel/sframe.h
@@ -0,0 +1,75 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * From https://www.sourceware.org/binutils/docs/sframe-spec.html
+ */
+#ifndef _SFRAME_H
+#define _SFRAME_H
+
+#include <linux/types.h>
+
+#define SFRAME_VERSION_1			1
+#define SFRAME_VERSION_2			2
+#define SFRAME_MAGIC				0xdee2
+
+#define SFRAME_F_FDE_SORTED			0x1
+#define SFRAME_F_FRAME_POINTER			0x2
+
+#define SFRAME_ABI_AARCH64_ENDIAN_BIG		1
+#define SFRAME_ABI_AARCH64_ENDIAN_LITTLE	2
+#define SFRAME_ABI_AMD64_ENDIAN_LITTLE		3
+
+#define SFRAME_FRE_TYPE_ADDR1			0
+#define SFRAME_FRE_TYPE_ADDR2			1
+#define SFRAME_FRE_TYPE_ADDR4			2
+
+#define SFRAME_FDE_TYPE_PCINC			0
+#define SFRAME_FDE_TYPE_PCMASK			1
+
+struct sframe_preamble {
+	u16	magic;
+	u8	version;
+	u8	flags;
+} __packed;
+
+struct sframe_header {
+	struct sframe_preamble preamble;
+	u8	abi_arch;
+	s8	cfa_fixed_fp_offset;
+	s8	cfa_fixed_ra_offset;
+	u8	auxhdr_len;
+	u32	num_fdes;
+	u32	num_fres;
+	u32	fre_len;
+	u32	fdes_off;
+	u32	fres_off;
+} __packed;
+
+#define SFRAME_HEADER_SIZE(header) \
+	((sizeof(struct sframe_header) + (header).auxhdr_len))
+
+#define SFRAME_AARCH64_PAUTH_KEY_A		0
+#define SFRAME_AARCH64_PAUTH_KEY_B		1
+
+struct sframe_fde {
+	s32	start_addr;
+	u32	func_size;
+	u32	fres_off;
+	u32	fres_num;
+	u8	info;
+	u8	rep_size;
+	u16 padding;
+} __packed;
+
+#define SFRAME_FUNC_FRE_TYPE(data)		(data & 0xf)
+#define SFRAME_FUNC_FDE_TYPE(data)		((data >> 4) & 0x1)
+#define SFRAME_FUNC_PAUTH_KEY(data)		((data >> 5) & 0x1)
+
+#define SFRAME_BASE_REG_FP			0
+#define SFRAME_BASE_REG_SP			1
+
+#define SFRAME_FRE_CFA_BASE_REG_ID(data)	(data & 0x1)
+#define SFRAME_FRE_OFFSET_COUNT(data)		((data >> 1) & 0xf)
+#define SFRAME_FRE_OFFSET_SIZE(data)		((data >> 5) & 0x3)
+#define SFRAME_FRE_MANGLED_RA_P(data)		((data >> 7) & 0x1)
+
+#endif /* _SFRAME_H */
-- 
2.51.0.355.g5224444f11-goog


