Return-Path: <live-patching+bounces-2923-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gFlQJlwMGWp4pwgAu9opvQ
	(envelope-from <live-patching+bounces-2923-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EFFCB5FCD20
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 05:47:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF0903031E80
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 03:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC73347BDC;
	Fri, 29 May 2026 03:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bfJoQni8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518BB78F26
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 03:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780026360; cv=none; b=pBnWgotx5pai+hEbUG4Z/9EM151HWMv3PfCmRhIW9+5yJcF7gKc60C4jenB8gpJ6CXUQrxRph27X+KLJ8KCpfDWV39iSv/hbGSOWovRXSlkmtA7Wc+F9SR8maFbJGK8PUtsK7cDiGd+hwvObOuiuVf7mySkFiBa/EWLS6K8U44s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780026360; c=relaxed/simple;
	bh=8zHQ3FwyzHpDJmIauKb4KTAcj4vOe1fC/aIs6dt9tuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K9Sf8a+Mk1AvJpf9Y8QIfF0x4jCJUrB5XrUnKnyi4sJBarYOAjZMwJj53R8BPH+4PjQlpQpINV6PeoF3VcTQm9eqq9XnUW1P7aYZY7VWnN7qKuaKfJRCPpc9LROv1LDTmpBltVtDqVqacaiz3bx0i4LFkbgnlkursbdZke2/D0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bfJoQni8; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-369576666d5so6633619a91.0
        for <live-patching@vger.kernel.org>; Thu, 28 May 2026 20:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780026358; x=1780631158; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7BHnXgj3nXdWPxqCTVcft+/Jbj+7+Z/5h1IG7aAODo=;
        b=bfJoQni8DkAflkZ64z5SMEbXzTr8AiVhx+EcYjpVsKcAv9TJi+S2h+d021X27uE0ai
         zWbou2KuGlcrqbatQSj7hZcZpTzMKAjYqMGX9nfDQZTv/dmqw0Y62fOOo65olGNeAL+E
         zGxm+ER43RjQctzeko6uilRDZj5nU7OLZ/8JsQdPhfOJXnFAZLrG2ZcWO7soKkotVB6q
         v+2pqP+3M9wIlMr1MIgQE3zVZxKgo0cMeamBaAlbg1cFcQSffyrfekrLH9iAXkZrBOuo
         3SP953SylNla9NsBuk6ijiO76BlMWaPXVq2g2v5JJ5j/KbmlxpCqRY5PNiv6prbyIsrf
         t//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780026358; x=1780631158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b7BHnXgj3nXdWPxqCTVcft+/Jbj+7+Z/5h1IG7aAODo=;
        b=elq7Caxu2R3WNnV/PDnYJM+9S/1b3tQMPi+aohWgy3GlfiIarYfag+Rajg3HmeYenN
         rQEZxKq8VTwUT+g5fkAVG1KH5igirK9k9vhBZLGizmG+pIIGCPCZBEMHXNyOSDBYqUMp
         7altHS5eQ8ai/m9HYyqgTwn0/Ekj3uGsX7GqKL1pQAb7xCSSNNIQ6CamndNeuQcmeECE
         cTeaSeapUWbLCdMxQsJqPFTPv7eiSCiWo50ihs7zni48l8A1Nfi0j3wpG+dHJEpUe8BA
         /eQ4O1rSbLB+rzhYPKtMpmjeYnGog47uq9dnxTEJBA3sPEWwsOPY2z6mK0HOS3Oq3BKK
         daqw==
X-Gm-Message-State: AOJu0YyOV/QnzY7oR4GOv/Paj2zs4Dtpezyw+iUPW5zY2pVVd1gpJDuo
	OfxzE6hAcBPSo0cJX/NMHlnUBnljwETp7TkALCtWlywpTIl24w8k04O2
X-Gm-Gg: Acq92OEVFUr/P0G+BRwZ5zKCU4FfPR/FmDBMpNAyQdbtnD1TNEH1xxI2+TA/sHaHs2S
	ErODnGRZ0YdOW1OJbjAua6m3U6eZzR1kVZnzhBO+HP7+Ez7A8siH5HbxqGJNPQyZs/r8o5Rc6mQ
	rfVkCekN8rfO4jHMtE2G+B7IO4f8R1Ikp4L/Cb58DrOpFhqWzCyTqY2Y+W6kX0YHQ6Y9Wfzjz7h
	/Y9ECw3GTNOWdf/+C5YBswT0r279aMBcPI0aG1rFH8ANjRGm8+2v2chphE479kjWOg/VuGsVqul
	w5Jszwyya2qoF/d+NKc7Q+AdMZblfXhX+bpFJC5eBjWXOCHCJoy+RMckyN40MGPzkRwI5wG8YnJ
	f8qkHIAkkGA4cgUpZp0m/+yC+3EeTja6jTLrv82gRhzGC71yETXCLtFK2m8SmB8a1ZKb78SV3nx
	7/639CreNCAcOB4mQqEmrtJtQgkjpqBmGA9PWTisliovsskCY8xWkUQI/dv8/y5NEiTL1KmeHGi
	YCKrqqKiugbjiR5679YHZTwt2s=
X-Received: by 2002:a17:90a:e7cc:b0:36b:218c:719e with SMTP id 98e67ed59e1d1-36bbcda6ba8mr1516020a91.21.1780026358502;
        Thu, 28 May 2026 20:45:58 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2000:3837:ec96:b29a:f0bb:6d68])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36bc6a340b7sm298385a91.11.2026.05.28.20.45.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 28 May 2026 20:45:58 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v2 1/4] livepatch: Make klp_find_func() non-static
Date: Fri, 29 May 2026 11:45:39 +0800
Message-ID: <20260529034542.68766-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260529034542.68766-1-laoar.shao@gmail.com>
References: <20260529034542.68766-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2923-lists,live-patching=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: EFFCB5FCD20
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Move klp_find_func() out of the static scope to make it available
outside of core.c. It will be reused by the upcoming patch.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 include/linux/livepatch.h | 4 ++++
 kernel/livepatch/core.c   | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index ba9e3988c07c..70854f542c33 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -215,6 +215,10 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 			     unsigned int symindex, unsigned int secindex,
 			     const char *objname);
 
+struct klp_func *klp_find_func(struct klp_object *obj,
+			       struct klp_func *old_func);
+
+
 #else /* !CONFIG_LIVEPATCH */
 
 static inline int klp_module_coming(struct module *mod) { return 0; }
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 28d15ba58a26..e97df3e59057 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -82,8 +82,8 @@ static bool klp_initialized(void)
 	return !!klp_root_kobj;
 }
 
-static struct klp_func *klp_find_func(struct klp_object *obj,
-				      struct klp_func *old_func)
+struct klp_func *klp_find_func(struct klp_object *obj,
+			       struct klp_func *old_func)
 {
 	struct klp_func *func;
 
-- 
2.47.3


