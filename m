Return-Path: <live-patching+bounces-2417-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GD6bDsAA6GlJEAIAu9opvQ
	(envelope-from <live-patching+bounces-2417-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:57:04 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98626440585
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 00:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EACA731071F3
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 22:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D2E73A7824;
	Tue, 21 Apr 2026 22:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s7XcmSRB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8883A782B
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 22:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776811947; cv=none; b=DH8JlzaxTBl9Jsc3ywl7dXEB1gjayRJw4E24v/Un6x7w/iqmadp7WXPtVAIr56/3qNwr0c64t6/kByxnEc6X6j+n6MMtAosZWw2SO6v8vY5jYqIdd2G8Js5cF+MBWjStbbw7U7GFLZN+DFO7ep9iDN8JYk1/3b+QfXPEIS0MBKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776811947; c=relaxed/simple;
	bh=HcHbWf4But37GRlHHhJj2shggv7jUZ569KAsIFqpDcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PujhfKzEgRgTnAtWm8xho20Hp+gUj+zZE1YroiQMmX9zLbsTWciZn8uIh6bOzHtx7lviVyQPKnnKT8erzMH8EbA48+cw2/KFZ5Q+tsDBSwrE0I3Pb2rwsas9CGBPpVKZ2gVKbGLa4yxUN6qIMLzJssKqH0ySisn02vORwLV9Aus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s7XcmSRB; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82fa1c94b37so2795467b3a.0
        for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 15:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776811943; x=1777416743; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P5zH7mctwcDOEQHijpP6Dn53P2ryMqn8C5QEWnKsM/M=;
        b=s7XcmSRBQfgDCQGXlsAVvq9QJV4rTbdp4qr4VO+UpoXUt7JKU95py7OuChdzxjOYKK
         hld/CsPt3Bdv2mWP3JN5ermXrOV+Ec8q2hlPXRYRPFUT863vrEuMDfqsS/MMneR5ZKku
         MjLEBSA6WAF2kHG2LMgWyQ2RNzgQ4vVvlYj3dsnAXBznAzIsqzTLpPWuJvPORrcycCyO
         QNvZKbsO7+LaGcue30s1W1lIlTQw6NZEfeSli3GlW7SJ/WlNWhjIQadgXVuEWOQlcp65
         JAPKEiPKs3Rso/CgXB/gvCMKVna9zEKOcioTzLGX0QFN/slvKrYkdCF9Yw+kgFTn0zDY
         149g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776811943; x=1777416743;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5zH7mctwcDOEQHijpP6Dn53P2ryMqn8C5QEWnKsM/M=;
        b=SnxAOED8XpoxgZ1t74Dd+ljmb/AOobi+iamlncgQ85jtkRf6QDpTT5iU2Cz9u1CPJN
         9r2ZQPIuuG/cZWfiOUQ451bKeFHQYzcYFlNIiycNJG3NMCkRDoCnjnmu9yybz8Xa7mG9
         l5kfyUfYPJ3EyWBwCGnES+PB0OwcO4ls+Mm8Pji4k/dN65hzSU/ANceHe43SUAeZB++g
         K4uELrVF2P/HdM0u79TzYxjJOzrK82Z7FM31JOJfAIYVxjlfReyy1dvJ/9acN+3t14SZ
         rxBSv8QgdWe4frBX0YnmHX3GmpwPs6f5nN1NNeIEmdC3O/IMLaEEOt8wV2GpR7kewJTf
         utdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/43Dl59N+IliIzzLzcL5BUHU2Jec64AQ9ALpgDNDfCgByz3wdpbta7V4+jG9nakdxl6Rf2rlTXuHvSjo9U@vger.kernel.org
X-Gm-Message-State: AOJu0YxCQvh3I88fOvjNTIKfYJMdePUPn1WsxEF7bgiIm1cw5WKbbNgi
	QRqxdtylPPf89If9xSDNNtDqDwpETLq1xpU/W+lMrj1TLlsYNzxw15tPhUjtxHhZR0Se9hurDUs
	2J26TiZySEO5NcQpgxgXV7KgoNQ==
X-Received: from pfbjw25.prod.google.com ([2002:a05:6a00:9299:b0:82f:b709:3747])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:a247:b0:82c:1cd0:2f7e with SMTP id d2e1a72fcca58-82f8b553974mr15760811b3a.20.1776811942482;
 Tue, 21 Apr 2026 15:52:22 -0700 (PDT)
Date: Tue, 21 Apr 2026 22:51:57 +0000
In-Reply-To: <20260421225200.1198447-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260421225200.1198447-6-dylanbhatch@google.com>
Subject: [PATCH v4 5/8] sframe: Allow unsorted FDEs
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
	TAGGED_FROM(0.00)[bounces-2417-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 98626440585
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

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
index fb3b6b2d8677..243027244854 100644
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
2.54.0.rc1.555.g9c883467ad-goog


