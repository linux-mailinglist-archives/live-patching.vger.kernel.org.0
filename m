Return-Path: <live-patching+bounces-2861-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GK/LMGgIDGoRUQUAu9opvQ
	(envelope-from <live-patching+bounces-2861-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:51:20 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 720F8578625
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 08:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 2C46030252B5
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 06:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5986D3ACF10;
	Tue, 19 May 2026 06:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J7ts8KM6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605BA39EF38
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 06:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779173423; cv=none; b=G+slkJ9r0mKrvZrW99P3nmRPJyeiBR40npy6J2575I2+NY1885pvKpIEmZgZdMp/1Yd3MCs0jqU0EwiQlGN0oENF4kW+DrO8desge/OheDHsMpUPqkR6TAjj4q2SySt8qrLU6JL0iqMdzIphrGjYDB1U9WgcViE5zwwE6ALgAxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779173423; c=relaxed/simple;
	bh=jVfugcjgdalF4aRphBnA3RWVR8TUBdRTnGXqTDdA0QQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Rt68mMC49UE9dQ9LFxCHE4IAs1b+7rDJG/y+Q6TzttAyPj6u9sUD24Sct/PVLCRQ1EXbUKAe2evh7m6iagISEaAIvLqBmqnSkzG6Y4MeaF8UNCS7R69c9+Ekk810Wu5MlnLP8TwJa6zc3mxq1TFQIp826JCPP7QR9VISI1f7lQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J7ts8KM6; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dylanbhatch.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8353b042152so4571513b3a.3
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 23:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779173421; x=1779778221; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VHkz/NgFKwMRIi/FlTPVEcadP4L/5L+4bREFqEJc294=;
        b=J7ts8KM6sORU5kBh5i1kiNbNyNFjPkUCrl6dVi2SGxHcETrFnXuo2329Y0qZIzmYFB
         hPuMAKymVJtjP7bb7nKZu0D2JW9hkWNexrR2XLbPllKye14+hPfYcVQpHJERigHNfMs/
         e3dxXKWvQGGW4yu/C9MF3HDOs9AMJdgTRv9G4XjtOti4O+k+yfoFSR0l5JcQKK2N+Shz
         4pfsT/MCqjH31dewXX4FSIqcbCx28QenWK9z2qxXJxRpV1y3yDga03DrfbDI2xldwABa
         /VElTYHNlB2Jq8hrL3ksytl5S1FSHVGN3UKZAMCx/tCfbX2Iyx7A3dGtACEpN7+xQEOZ
         YXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779173421; x=1779778221;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHkz/NgFKwMRIi/FlTPVEcadP4L/5L+4bREFqEJc294=;
        b=eIGQKJefcMYOpgZMuf3s/3qCSkVGRFltmjEh1yqNOcRp3s4b7dj/5bI6DaeMhNcmyK
         Xubdu9LndpmHKQOhC3Fj/YgH172v0aAR4O3CaP5+QXCpRFRw98PPQKOs63Qx0JWg2RPN
         /8iWgfC+cVokBPklyUTX6bOnI3BsnaRqiXY0DHZaBvGEujklP1denkOtDaiFgxz1HpJy
         NTjLtO9MtgPEKvxFsSPdwtEs7guTstZ1NnvFLDB8S3HUkW/H28Ff/GC8lrd1XqkQCEqz
         W+GST+0Xa4YyzTHkYwpEhSFF831DAsCpFjs2w+6bukxBwlmQ/DHHHnsAJ0WZHkn779ao
         gErw==
X-Forwarded-Encrypted: i=1; AFNElJ9vTl7oX+Wa0aSVpWDNbKeSYLS8nLzokQkggyaBCAJlnXBi4H7IZmS5rXL1HVRpAQuOWAFCOxgW9qPmaRUm@vger.kernel.org
X-Gm-Message-State: AOJu0YxX5hVqIh/rJMONZdYqig2YHBZbngy5sL6kDz+UsKmfaS0ivtuY
	iKzShcA+KQ3qc9KB5cZwvfvw5NCXVPzmSzA0hev3N3nPwOwAMTzZp0ytjgscMq55jmJ7Fp4kLlu
	uzdiT1AjjbMYYTWLau9pZx8KGpg==
X-Received: from pfbg11.prod.google.com ([2002:a05:6a00:ae0b:b0:83a:68c:e1c6])
 (user=dylanbhatch job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4214:b0:83d:b11f:796c with SMTP id d2e1a72fcca58-83f33f31c40mr20319191b3a.49.1779173420344;
 Mon, 18 May 2026 23:50:20 -0700 (PDT)
Date: Tue, 19 May 2026 06:49:49 +0000
In-Reply-To: <20260519064950.493949-1-dylanbhatch@google.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260519064950.493949-1-dylanbhatch@google.com>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260519064950.493949-9-dylanbhatch@google.com>
Subject: [PATCH v6 8/9] sframe: Initialize debug info for kernel sections
From: Dylan Hatch <dylanbhatch@google.com>
To: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Jens Remus <jremus@linux.ibm.com>
Cc: Dylan Hatch <dylanbhatch@google.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>, Mostafa Saleh <smostafa@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-2861-lists,live-patching=lfdr.de];
	TAGGED_RCPT(0.00)[live-patching];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 720F8578625
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Setup the optional unwinder debug information for kernel .sframe
sections. Modules are indicated by the format "(<module-name>)".

Suggested-by: Jens Remus <jremus@linux.ibm.com>
Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
---
 kernel/unwind/sframe.c       |  4 ++++
 kernel/unwind/sframe_debug.h | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
index e8ede0343cb2..d256e72620fe 100644
--- a/kernel/unwind/sframe.c
+++ b/kernel/unwind/sframe.c
@@ -1036,6 +1036,8 @@ void __init init_sframe_table(void)
 	kernel_sfsec.text_start		= (unsigned long)_stext;
 	kernel_sfsec.text_end		= (unsigned long)_etext;
 
+	dbg_init(&kernel_sfsec);
+
 	if (WARN_ON(sframe_read_header(&kernel_sfsec)))
 		return;
 	if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
@@ -1099,6 +1101,8 @@ void sframe_module_init(struct module *mod, void *sframe, size_t sframe_size,
 	sec->text_start   = (unsigned long)text;
 	sec->text_end     = (unsigned long)text + text_size;
 
+	dbg_init(sec);
+
 	if (WARN_ON(sframe_read_header(sec)))
 		return;
 	if (WARN_ON(sframe_sort_fdes(sec)))
diff --git a/kernel/unwind/sframe_debug.h b/kernel/unwind/sframe_debug.h
index e568be4172b1..6c7ab3aa7c9e 100644
--- a/kernel/unwind/sframe_debug.h
+++ b/kernel/unwind/sframe_debug.h
@@ -32,6 +32,19 @@ static inline void dbg_init(struct sframe_section *sec)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 
+	if (sec->sec_type == SFRAME_KERNEL) {
+		if (sec == &kernel_sfsec) {
+			sec->filename = kstrdup("(vmlinux)", GFP_KERNEL);
+		} else {
+			struct module *mod = container_of(sec, struct module,
+							  arch.sframe_sec);
+			sec->filename = kasprintf(GFP_KERNEL, "(%s)",
+						  mod->name);
+		}
+
+		return;
+	}
+
 	guard(mmap_read_lock)(mm);
 	vma = vma_lookup(mm, sec->sframe_start);
 	if (!vma)
-- 
2.54.0.563.g4f69b47b94-goog


