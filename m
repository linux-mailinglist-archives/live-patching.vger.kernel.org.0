Return-Path: <live-patching+bounces-2595-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFNVHM3+8GnubgEAu9opvQ
	(envelope-from <live-patching+bounces-2595-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:09 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F2F8B48ABFC
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:39:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 16ADB30E39A5
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 18:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A698D47B41D;
	Tue, 28 Apr 2026 18:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bWvTgcYK"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CF447B426
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 18:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401445; cv=none; b=Er1H/9cj1DHF6oTP91xU7fWk0rLsinIt40O32SE6lAwcyveMefgiFPAukvu+TusquWhGHiGOYReGyz+c21d+fCEgmkUmCbCP+DNToJ6WET1RTnV5IGFuwHgwMd1bU7hG0kflMhOsePIRT3HZPAqS2+Pll51eLyFP8iID030T3xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401445; c=relaxed/simple;
	bh=zsbBPiSMTY+4JYf4sn3CPXmmxXgtYh5S3I+3ssE0e6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cs1wY+aUfqyomPJnKHXz8RbNKyLx5F8bqUSKmaZd4I12+tDWrV0sD5hr750KmRylRbwVOOmq9/G7MZoQumH+58FCnKBTYOuGujM4Iu13vbxBr9yh595GNeU2HRTKVn48i8FJzMrZCqVjGsQ0GJrN8cYYjNz2OSBRIdMwVZ1XTGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bWvTgcYK; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35da4795b3cso22941695a91.2
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 11:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777401442; x=1778006242; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HEk4CM6KkrmWUN7H1Rd0LwOd0ZnJZhF5RnXyjlQj1vc=;
        b=bWvTgcYKtxjAm4s8vmwxCVHLZfs+YYh47l5rhwi6Xs8d+9FnMsVUaocvRuR4m+HzmH
         GFRfltfwTIUffp7zKkY97sdeNeec9gs6zzTAn/U/q6DGc9l4nTRsaLYkeq4v/WAXAhNb
         K5NMV3jlgu8y/KaGCkk9oEA/AUK9ua/iA1e+z1qQHpItwsPCYdIwu5xVlhrAk3915hXR
         FmN0km7W/WtXlkpnlvVgJ0XC1YK9bEenZY2anUWw5DDRqwaBqKJZRswcjl6FQEZQ7mkq
         lbNpztfLGQCrDPdonnqMg6Oa+PntzjUoK922lAyM+Ap8CT0iaRcdtv0jpwTrSn+H4Lg5
         2oSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777401442; x=1778006242;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HEk4CM6KkrmWUN7H1Rd0LwOd0ZnJZhF5RnXyjlQj1vc=;
        b=Pt7iGgU/XwL+IUg2bhK/tVqxbdMliwF6tW8C7G5WU54QlJzab38DSIqLnHk85axrUx
         iwZ1mKVqYu7/Daq/i15ZqK40BjA9vx8nVUMHOSRaB57qLo1WX0CwqbevabaY6AH58euA
         0mCaRg7CYGaVwOVg5NzrwB50mXQnRBSgOsxnv4A0Nz1X49Ahuwz0Z2xzsA+rgGSoB+x1
         ozZjDWJajbMHXk/5QFsCYEyp4hHpE5XbEl20WgrrqcPy1L0ifKDd6SHwM8MrWV4n9xOp
         09lNbc7gMRPZ+uPKhDv4UuQqhT1h+7KXDOdCDJLVXpO93f361ohgZ+UIiedqzVCs+TAu
         jf7w==
X-Forwarded-Encrypted: i=1; AFNElJ9fhr8yTx9b6UcRqTJRPzZ08d0oApppcESTiaB3Kh+k8/TupHywEiQ+qxzFdQldIPOyzVJOcORsepgJ5zkM@vger.kernel.org
X-Gm-Message-State: AOJu0YzlkRYtJaX+kvV4TVtFK4JFq3G8ttk8Epg1XheO1k0RVM8hDqUH
	pIxBky+6kDc+dE35Exn0mNXd0ydCrk9vzbcp+fFID/5QLdhbfm33KO1GqvzThl3up1RX0HBtZ4a
	IqQ5G76cU638YH1QgY2Jt+EwLLw==
X-Received: from plbjl20.prod.google.com ([2002:a17:903:1354:b0:2b0:b22a:e6ef])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2ecd:b0:364:7467:53e5 with SMTP id 98e67ed59e1d1-36491ff60aamr4439314a91.2.1777401441910;
 Tue, 28 Apr 2026 11:37:21 -0700 (PDT)
Date: Tue, 28 Apr 2026 18:36:40 +0000
In-Reply-To: <20260428183643.3796063-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260428183643.3796063-6-dylanbhatch@google.com>
Subject: [PATCH v5 5/8] sframe: Allow unsorted FDEs
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: F2F8B48ABFC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	TAGGED_FROM(0.00)[bounces-2595-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

The .sframe in kernel modules is built without SFRAME_F_FDE_SORTED set.
In order to allow sframe PC lookup in modules, add a code path to handle
unsorted FDE tables by doing a simple linear search.

Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 include/linux/sframe.h |  1 +
 kernel/unwind/sframe.c | 45 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 5b7341b61a7c..8ae31ed36226 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -28,6 +28,7 @@ struct sframe_section {
 	unsigned long		fres_start;
 	unsigned long		fres_end;
 	unsigned int		num_fdes;
+	bool			fdes_sorted;
 
 	signed char		ra_off;
 	signed char		fp_off;
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 430bff9533ee..dcf4deb378dc 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -176,9 +176,35 @@ static __always_inline int __read_fde(struct sframe_section *sec,
 	return -EFAULT;
 }
 
-static __always_inline int __find_fde(struct sframe_section *sec,
-				      unsigned long ip,
-				      struct sframe_fde_internal *fde)
+static __always_inline int __find_fde_unsorted(struct sframe_section *sec,
+					       unsigned long ip,
+					       struct sframe_fde_internal *fde)
+{
+	struct sframe_fde_v3 *cur, *start, *end;
+
+	start = (struct sframe_fde_v3 *)sec->fdes_start;
+	end = start + sec->num_fdes;
+
+	for (cur = start; cur < end; cur++) {
+		s64 func_off;
+		u32 func_size;
+		unsigned long func_addr;
+
+		DATA_GET(sec, func_off, &cur->func_start_off, s64, Efault);
+		DATA_GET(sec, func_size, &cur->func_size, u32, Efault);
+		func_addr = (unsigned long)cur + func_off;
+
+		if (ip >= func_addr && ip < func_addr + func_size)
+			return __read_fde(sec, cur - start, fde);
+	}
+	return -EINVAL;
+Efault:
+	return -EFAULT;
+}
+
+static __always_inline int __find_fde_sorted(struct sframe_section *sec,
+					     unsigned long ip,
+					     struct sframe_fde_internal *fde)
 {
 	unsigned long func_addr_low = 0, func_addr_high = ULONG_MAX;
 	struct sframe_fde_v3 *first, *low, *high, *found = NULL;
@@ -233,6 +259,15 @@ static __always_inline int __find_fde(struct sframe_section *sec,
 	return -EFAULT;
 }
 
+static __always_inline int __find_fde(struct sframe_section *sec,
+					     unsigned long ip,
+					     struct sframe_fde_internal *fde)
+{
+	if (sec->fdes_sorted)
+		return __find_fde_sorted(sec, ip, fde);
+	return __find_fde_unsorted(sec, ip, fde);
+}
+
 #define ____GET_INC(sec, to, from, type, label)				\
 ({									\
 	type __to;							\
@@ -657,7 +692,7 @@ static int sframe_validate_section(struct sframe_section *sec)
 			return ret;
 
 		ip = fde.func_addr;
-		if (ip <= prev_ip) {
+		if (sec->fdes_sorted && ip <= prev_ip) {
 			dbg_sec("fde %u not sorted\n", i);
 			return -EFAULT;
 		}
@@ -736,7 +771,6 @@ static int sframe_read_header(struct sframe_section *sec)
 
 	if (shdr.preamble.magic != SFRAME_MAGIC ||
 	    shdr.preamble.version != SFRAME_VERSION_3 ||
-	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
 	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
 	    shdr.auxhdr_len) {
 		dbg_sec("bad/unsupported sframe header\n");
@@ -766,6 +800,7 @@ static int sframe_read_header(struct sframe_section *sec)
 		return -EINVAL;
 	}
 
+	sec->fdes_sorted	= shdr.preamble.flags & SFRAME_F_FDE_SORTED;
 	sec->num_fdes		= num_fdes;
 	sec->fdes_start		= fdes_start;
 	sec->fres_start		= fres_start;
-- 
2.54.0.545.g6539524ca2-goog


