Return-Path: <live-patching+bounces-980-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6950FA11BD3
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 09:26:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83E623A5600
	for <lists+live-patching@lfdr.de>; Wed, 15 Jan 2025 08:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A783DABE0;
	Wed, 15 Jan 2025 08:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fWrUKIaO";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fWrUKIaO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC1028EC65;
	Wed, 15 Jan 2025 08:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736929537; cv=none; b=ZXLvlLSZYJSwZPAAKzwng8lXN8IJYkNX3gpUL28blgC5VKEk3DH9i8t6hYjM2p5m0TyCoq+QFU5sQ07fcs4p1q8LC6iQgVGDGT/pQRSOfKHznw3qMJp+qEoAzVtpu8D0r/HDQIiaStUoD4JTSLMXwfxnwMKIZ9s5qYAiqmIcu3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736929537; c=relaxed/simple;
	bh=WpDtr3D9908NMYXv+uWPCuwNXuvymxMMVXgONcR/yHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMXImJSJe9WEG9ra/brMEX21L3Io7UCOQH4b8kvzx58ACy5TGPXoUqT5sLl+7Fg8xcvs2+PE1hu8dTbRO4LR8MwcL1CQeKj6RTuq8IqJcIgH/Aj1dnlDb5YFLt/D5ZGRxJSWoU6bgshlihVq+oXndrECiWGrsPckEyy4dpqoCUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fWrUKIaO; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=fWrUKIaO; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from pathway.suse.cz (unknown [10.100.201.202])
	by smtp-out2.suse.de (Postfix) with ESMTP id EF7971F37C;
	Wed, 15 Jan 2025 08:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQvtRTEW+KaxvNQ+F0E0rfsumD1yVk/X2iF4fgnw1p8=;
	b=fWrUKIaOW4wasx1SdI22mNxpOD7q58BxZ/2ALHlCEe9Y06SKORo7scJyABrNU2Rng5AWAv
	sDjce33V4M24gfUB8FIaBz0DFAf6ZYTFg2neq7k1F9Mn+vmEEQZXo4JQqDQ7LelPO05cWo
	jApdFFNZulsEcVtuiEOElM4F5+RUwz8=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1736929534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nQvtRTEW+KaxvNQ+F0E0rfsumD1yVk/X2iF4fgnw1p8=;
	b=fWrUKIaOW4wasx1SdI22mNxpOD7q58BxZ/2ALHlCEe9Y06SKORo7scJyABrNU2Rng5AWAv
	sDjce33V4M24gfUB8FIaBz0DFAf6ZYTFg2neq7k1F9Mn+vmEEQZXo4JQqDQ7LelPO05cWo
	jApdFFNZulsEcVtuiEOElM4F5+RUwz8=
From: Petr Mladek <pmladek@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	Nicolai Stange <nstange@suse.de>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>
Subject: [PATCH v1 05/19] livepatch: Remove "data" from struct klp_state
Date: Wed, 15 Jan 2025 09:24:17 +0100
Message-ID: <20250115082431.5550-6-pmladek@suse.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115082431.5550-1-pmladek@suse.com>
References: <20250115082431.5550-1-pmladek@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_COUNT_ZERO(0.00)[0];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email]
X-Spam-Flag: NO
X-Spam-Level: 

The "data" pointer in "struct klp_state" is associated with the lifetime of
the livepatch module, not the livepatch state. This means it's lost when a
livepatch is replaced, even if the new livepatch supports the same state.

Shadow variables provide a more reliable way to attach data to a livepatch
state. Their lifetime can be tied to the state's lifetime by:

- Sharing the same "id"
- Setting "is_shadow" in "struct klp_state"

Removing the "data" pointer prevents potential issues once per-object
callbacks are removed, as it cannot be used securely in that context.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 include/linux/livepatch.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 56e71d488e71..d02d7a616338 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -175,14 +175,12 @@ struct klp_state_callbacks {
  * @block_disable: the state disablement is not supported
  * @is_shadow:	the state handles lifetime of a shadow variable with
  *		the same @id
- * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
 	struct klp_state_callbacks callbacks;
 	bool block_disable;
 	bool is_shadow;
-	void *data;
 };
 
 /**
-- 
2.47.1


