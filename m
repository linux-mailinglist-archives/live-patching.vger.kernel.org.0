Return-Path: <live-patching+bounces-2803-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +KdqGAaZBGqILwIAu9opvQ
	(envelope-from <live-patching+bounces-2803-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:30:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E524D53627C
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 17:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EA648315CFFD
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73150449ECB;
	Wed, 13 May 2026 14:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NBqe4wQ9"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1B633CEA8
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682859; cv=none; b=ZvzeRi+cpR7WPBORmrzP7qOc+nd5Q0yPng/wBwvHP/2rLgug919/AwYDrztWMBVatQ+HqDfWCAzoQRStThY1qAQ7HZ0RskpS0UcuSkNCjW8wAU4WznNMIvXoEpZWg+cAFP65n8NacfS4Dani+3AXZcf2KK3fw3w7oq9BSH3Z9vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682859; c=relaxed/simple;
	bh=xtYoMVLZv9SI5q1L030p/bDLCbosa//sRXpxOMmdMGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOLJEwdIXd6+Jft75ZhVOypLLdka5MjxkDK8zJ/Y2H/4oAFnpV84DsD+aBeCTrf1XH5l4ByNqD6hNcI6/wb8vmElLKhZGUF1AqX9caGHC/QZK9zNWHcz8BJKw6np6RVdH9bHs2EqPY+Qq63SbyIrvj15NEDVEVz/A4nBp16/YRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NBqe4wQ9; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c801d732058so3343534a12.1
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682857; x=1779287657; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvCFuoYR0n55lxzR+3wSEV9nPIpMbdRxEeeyjTGUzEE=;
        b=NBqe4wQ9QdSlF+2Is9Q+mj0xH5VzaTM8PSme8uEPUGVEJjmszGvpnWSjOz5hYNbGqU
         0BxlfHZNzAqpWPM0ZjyqNswzv3KsQza/cvqmlz+0FBf35S8665gUG26y5PiSolPLqWaL
         //5m+EGVNrprE7pgTEZzvRAw7NqTif+XFatKcDhL1z9TZ1vo2p+RYJrercBoG2AkVN5g
         7flgdzm2AysR7ZTN34nYwfjCVRi1Rasz4NSpRTB6L++GuKG4bMnRNTzfltKv+xiMTFux
         9h4DQkrVBj+IeFN6AqCAcUpL64W/+MfCa3pV3NnGIpkKtCMeV5k1VAuIp7qBaC1JjsHf
         Imvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682857; x=1779287657;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rvCFuoYR0n55lxzR+3wSEV9nPIpMbdRxEeeyjTGUzEE=;
        b=L5keyRrYEIS36sO8pr2e6Bom+ChpQn1HtFTRP9bCFgjzFhBYSxawBlLMGFbUVdlvJJ
         jxyD0i8xFVNWLRDFtKSeraaQ4hQ/t5Baqfj8BoTfGQM4+0ycqc6uDfUkaVJmh3ZuxY5m
         dI6nuexsjtNaciERqwUh3N8jzcaRwyg6pznonrywBQzHJhQ11lR+JR4VsyBod5FI3KZO
         NuBFiM6RFxWjQqyeDX4ewo+aLcZ8em0MaoD7GO+7YtkBUYqKwb8TtLzEV5IfxongzQlX
         aZaLNTmAC3UEjgkJgFmCCjJr0QILibVxNEcxAUdyr+eHWc6ToBYJi6n8WIuh8M2cFbPO
         gYKA==
X-Gm-Message-State: AOJu0YxFtRbvCbYHABWWLH8TrU+X67XTiERk6KKBf5ZLpCwvJRcKDCxp
	YMmHWX1tRfuzLOm4mzXPMPDdyjjQ+97XN+ZWu+2YmYTGfPV96r39OP9K
X-Gm-Gg: Acq92OE93zwE/vLY7xXeSuPBzefkDv4YkbO3kkGZF+Tl1rrZdOso6bc/WIfJc62Z+VF
	6NVVc/S3PVkrshV7sHvCbDxrC+0rOFKdLrYUNq/cKZrFLT0Dx0+1mMFSYjBIM6K7WplI8hZkbsi
	LB7FX9fBjP3+LQJqf3mB7x9TGkFkH7GBbnPTQW7onnCqCooIV0+RAHtc/M0cMFFmOVBUZxF0YAn
	AYQd5Zp1IoKhcmW6PxYEpHalXgCkq48MrhpESzS8hyT7BCwxHWSoagc16lf1hlIt/O7g9uegWnk
	WgYugU6lNozLur24BbHcQADDKUqp9JEl1xWcYMmklFpvLZm6bYx3lql8R13o4q59GmuYdxDjEsf
	ScqzdxUDRsNzxK7IzTxstWxw/O2bistFe+LW8hVVPKIEiRD+SFEiBryKvqo05N+HK2Ct3Km7mk6
	Bb9sZ7lpK0nFJsTIWy8CB1yu3/9mVBia5pZHylI3UXccsatd4DnlHJOXLUfVB+OUwMlRpLd40Qi
	sYP9iq4fCJzsJ0=
X-Received: by 2002:a05:6a21:6d82:b0:3aa:c93b:625e with SMTP id adf61e73a8af0-3ace2100368mr8798809637.36.1778682856607;
        Wed, 13 May 2026 07:34:16 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.34.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:34:16 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org
Subject: [RFC PATCH 4/6] livepatch: Remove "data" from struct klp_state
Date: Wed, 13 May 2026 22:33:19 +0800
Message-ID: <20260513143321.26185-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513143321.26185-1-laoar.shao@gmail.com>
References: <20260513143321.26185-1-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E524D53627C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	TAGGED_FROM(0.00)[bounces-2803-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_SEVEN(0.00)[7];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Action: no action

From: Petr Mladek <pmladek@suse.com>

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
index be4584044cf4..340b04a0de83 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -152,14 +152,12 @@ struct klp_state_callbacks {
  * @callbacks:	optional callbacks used when enabling or disabling the state
  * @is_shadow:	the state handles lifetime of a shadow variable with
  *		the same @id
- * @data:	custom data
  */
 struct klp_state {
 	unsigned long id;
 	unsigned int version;
 	struct klp_state_callbacks callbacks;
 	bool is_shadow;
-	void *data;
 };
 
 /**
-- 
2.47.3


