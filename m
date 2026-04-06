Return-Path: <live-patching+bounces-2303-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGS3OcgA1GnmpAcAu9opvQ
	(envelope-from <live-patching+bounces-2303-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DB393A6640
	for <lists+live-patching@lfdr.de>; Mon, 06 Apr 2026 20:51:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 064C6301372F
	for <lists+live-patching@lfdr.de>; Mon,  6 Apr 2026 18:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCE7396D15;
	Mon,  6 Apr 2026 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCsWdMtI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D55396B78
	for <live-patching@vger.kernel.org>; Mon,  6 Apr 2026 18:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775501429; cv=none; b=gU4FUZ9AsE3vMYrZgpP5ChYlG/zz9dC/+qyyTjCC/wXNjNsPkP7RwBmROouXEvbTi0XeClACsBBbrXgoPWfVspY3oKREFVnJNjfFzjInrR/h3Jj7sB5lME6jixbY8xskk060kk8rKZrkX1GEoRBF2xqnpzdPjh0xfe//JPlCges=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775501429; c=relaxed/simple;
	bh=02IiNGebjj9T3GiLIb7uKCtJskYIhB5w0FLa54z1BU4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bKMYe5OZJpxhDnN3eVQOzVo+k6eDy3Q0Us3UpM6iAPQfU3xVNlCJ64QibQo3tobBlEARTeQOZUe8nVahMUp1r9gSUWxHXfnNCL1W24opt31S132rudEAnBSf+cwCZquB3XE/QCngJIX+JExIOPrTTsBbWTitOSfoJ2Spm4MdQG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCsWdMtI; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82cd9fa608bso7530918b3a.3
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 11:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775501428; x=1776106228; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/itz4DVMHOse/koMe29mOhSeC8aYBjPMHAwpbzHRlRM=;
        b=XCsWdMtIyYWPkfogzDOpwlG9w3sEVxM0stkgl1qjY6p/LAWpcPYxzMWnhzvpDRizk8
         oWfzk0gop6im7F7rrf2WZcPbYfEpfSn08eWL+cOplrR2Gix4/QkpWXlxYyJgzWdlj7+z
         sKvKoABZgn+hlmQSjKFhF8qk5d6/+JDXX4bql/NYW4U2XN3+4xobHqv6g55qMQksnzOW
         ZfXwVx8P1brrDI2ktVKRjMCUaMct8WPT1iRVAf7wEwvDLdAx9QIzzPmzIl3BkZMmU5M2
         M2AlSn/oCGyGeLFAJgvp3/o+hHMEsj9xbXnHmWQNRxzm0nIuurOq1R6XBEZk9VEiDHw7
         nhOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775501428; x=1776106228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/itz4DVMHOse/koMe29mOhSeC8aYBjPMHAwpbzHRlRM=;
        b=rfnyg2OozZjhRwXO2JdxvuZ+MLa+6NfaV982ryIrsi14q9fwyCzG6tTk6dDfdbh6/R
         e1KXHcMCsNONJK1hVrysXyvlABhOkKCDE1tGJfiVP5OLLh1La7++ZFT2Jr5dgQ4h0z4I
         31saq63+72KnEVyhE+srr+E/uVTi2C1GxNdfcp6I0BsduMzP/SXEH8UJD5k+tmYn1Oo0
         zJw/rrcJlZ/O2KGnyIBFYKNf64Rr0sgpXqnKbIzSPVHvz/QR5KqqE08AhzzmBmzw6k5m
         S3bKqWCCnS48YuNeeOqc6Z3E23XTR1wBEYOzHs/F/KMpD35C2Joj2V4W65KPfroQUq9u
         UU2A==
X-Forwarded-Encrypted: i=1; AJvYcCVOWOb/YjLqwQv1ghBbn3d9eO6k8rCwmcM6+d33cxmoeYaVdYKe1u3Y3+O6T8MQAVdBWPcdP1KBPm6hn/br@vger.kernel.org
X-Gm-Message-State: AOJu0YwcRGcPdZowakQkzvezRM54Qm/h0BF54RKLFP2j0qjFJJLo65s7
	JJhOYYMgI6YY3KuNfmeDvbwTbJUiBuTf+g0d5XRmec7RqR/sgHDjEwY1TDopaj0nkj08gniVCpx
	5fl+bbsav2odgy8Xjs3eyhbgcPg==
X-Received: from pfbbj11.prod.google.com ([2002:a05:6a00:318b:b0:82c:de4c:2172])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4397:b0:823:9c6:1985 with SMTP id d2e1a72fcca58-82d0da8a9bbmr13916077b3a.16.1775501427782;
 Mon, 06 Apr 2026 11:50:27 -0700 (PDT)
Date: Mon,  6 Apr 2026 18:49:57 +0000
In-Reply-To: <20260406185000.1378082-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260406185000.1378082-6-dylanbhatch@google.com>
Subject: [PATCH v3 5/8] sframe: Allow unsorted FDEs.
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>
Cc: Dylan Hatch <dylanbhatch@google.com>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	Jens Remus <jremus@linux.ibm.com>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2303-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[20];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1DB393A6640
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The .sframe in kernel modules is built without SFRAME_F_FDE_SORTED set.
In order to allow sframe PC lookup in modules, add a code path to handle
unsorted FDE tables by doing a simple linear search.

Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 include/linux/sframe.h |  1 +
 kernel/unwind/sframe.c | 44 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/include/linux/sframe.h b/include/linux/sframe.h
index 905775c3fde2..593b60715cd6 100644
--- a/include/linux/sframe.h
+++ b/include/linux/sframe.h
@@ -64,6 +64,7 @@ struct sframe_section {
 	unsigned long		text_start;
 	unsigned long		text_end;
 
+	bool			fdes_sorted;
 	unsigned long		fdes_start;
 	unsigned long		fres_start;
 	unsigned long		fres_end;
diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index 321d0615aec7..4dd3612f9e7a 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -179,9 +179,34 @@ static __always_inline int __read_fde(struct sframe_section *sec,
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
@@ -236,6 +261,15 @@ static __always_inline int __find_fde(struct sframe_section *sec,
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
@@ -660,7 +694,7 @@ static int sframe_validate_section(struct sframe_section *sec)
 			return ret;
 
 		ip = fde.func_addr;
-		if (ip <= prev_ip) {
+		if (sec->fdes_sorted && ip <= prev_ip) {
 			dbg_sec("fde %u not sorted\n", i);
 			return -EFAULT;
 		}
@@ -739,7 +773,6 @@ static int sframe_read_header(struct sframe_section *sec)
 
 	if (shdr.preamble.magic != SFRAME_MAGIC ||
 	    shdr.preamble.version != SFRAME_VERSION_3 ||
-	    !(shdr.preamble.flags & SFRAME_F_FDE_SORTED) ||
 	    !(shdr.preamble.flags & SFRAME_F_FDE_FUNC_START_PCREL) ||
 	    shdr.auxhdr_len) {
 		dbg_sec("bad/unsupported sframe header\n");
@@ -769,6 +802,7 @@ static int sframe_read_header(struct sframe_section *sec)
 		return -EINVAL;
 	}
 
+	sec->fdes_sorted	= shdr.preamble.flags & SFRAME_F_FDE_SORTED;
 	sec->num_fdes		= num_fdes;
 	sec->fdes_start		= fdes_start;
 	sec->fres_start		= fres_start;
-- 
2.53.0.1213.gd9a14994de-goog


