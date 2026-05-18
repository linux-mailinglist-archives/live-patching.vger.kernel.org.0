Return-Path: <live-patching+bounces-2841-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QEntAYKGCmpg2gQAu9opvQ
	(envelope-from <live-patching+bounces-2841-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 05:24:50 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 591AC56568F
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 05:24:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1AD6A300DE1A
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 03:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734E03803D8;
	Mon, 18 May 2026 03:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dm1pkotm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A158212542
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 03:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779074687; cv=none; b=ojk0n8qlD+YHumTK6lHNVQiDbbhx4N+IZk5LnICuhopMQ+Bj/pfxS7+HDVCpnLWRa5G3iwaa1Q0lOUFKqteiykVPgruGSIDWbcq1fmWOPAQyjrC9J4U6Ecw9uaNczCFNK2uv/I85qmd0EJ4dra7D0iXwlFZn+MSayHYFrAlm9Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779074687; c=relaxed/simple;
	bh=pTLlp5bzp9ouQFshixLL/vuTExg1XTsP7YGkmFuARog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=siHuxr0atb942NXKXz200AMAQWuQbKa/rMEf/oqpCUdOLT81OVJ9Vv2+Bl1H7QdvrOQrpVK5w0bCp/LZ58RAQAeyQPzpnzmnaPyYvTpgo96YWvw6k328LHKo8pnScttUssxuKjVjRvqbxpdSK7pBkUVqn0J3qpHAvW7XNO+qZ68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dm1pkotm; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c8027e876fcso613491a12.1
        for <live-patching@vger.kernel.org>; Sun, 17 May 2026 20:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779074685; x=1779679485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3928H8NXYePWZBZfOKMv4+zmyhzTHFKKV0PQCWA/vU=;
        b=Dm1pkotmiITE9U7ByctyuRWv8LbSNF1zZEjhsQU/P/Wj/bhp9o0zbdwju/f8xok1lq
         NmXQ4XUY71URYqkqAtgfBr5iDbiRYwnV2xcTjtgQnpGR0kGkc2IYIhoxHpAmXOWAFcjo
         uU1FLsSE5tvIYr6YOa6jYFHVYA2G6VS2TUkV+iiML1kdm+Oa2QJCe9SVGl0Dzr/AjHfu
         HzyBCL+WvHmQCGfz+G4FfLxGrSEcJniTlXuHgtQvq6EhNiivK0pQxrNgF0jbX7hEuZKl
         EBVJHd0GQPb7V0tcoQpgE+SSfgNuSULKwyd59kNZmAZiUfU3TmMlGAMQi5ANl92wMCqL
         wIcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779074685; x=1779679485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/3928H8NXYePWZBZfOKMv4+zmyhzTHFKKV0PQCWA/vU=;
        b=hYHLIGYNeyViE6UO2pjCNS1paAg8r9W3isrOSmqLNmrkxT1mplNSixzCBYWUYqL28q
         Bsu0tV/Ncg9IrTdWRQPzmE3QzIvIy0e2vsE3f6nl3+wp2zuiLjGNiIYl+72MLSFKSogu
         5QU9fJJnnpfSpks3TBwbb+v+gMWZoCKSzm4rrE6DRZmVO+zvEEtGBL9irK6V66oGVt6i
         lQE6jH23hcC7IBjxOrbWzD8OyVpYpA4uOJS6vG5HFPPwboUEuFNmgumnFJmckbO/7j7v
         Ksuq2W2xEBUlQ93En0Q3GdYjELr6tqTrF2VYZ1MFAChVuG3eoGp6OwLx/oRmUoMk9fEv
         B+ng==
X-Forwarded-Encrypted: i=1; AFNElJ/2KtLYDwwCFzesuqel9dQQaac3bVeB8Iabm+J963EcsxCOkfyBLk1RCfBqAQ+IrK77UhnavjQ6tWbJnwLz@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/J2KuOTxVchSFb7L8xlzbiQlv7rriFjT/JVvmEHTQj6HbQDsv
	ecQHno21P/IC95SA7tuAZrwHF/eHGqLArk2bp0X660Vz6qEQRhdFIRHfLDIMG1rkrpk=
X-Gm-Gg: Acq92OG/H7e7g0ex3yWiQGqcWfagqgEMbZxsIo6zWcyH7ghwcCWuVXeY+mdnCSCDehU
	r21pm1EEXzM00nbE1aaAIfx6QNHmFahwBYhhwnN60mLLg8w5tjjgtZqL7TRz4Yv+wiiyuwMBCgn
	LWV17whEXJkcVKdgwbolZa/JSYayQ/GEwf+lhAAk/HcdsU5PaT/i4MSFsEAx3Mt6fpU6+Q9YH/9
	XlHlPIUSswbgjM8SvLdRAjWbRJv4igUKHRLRaWllA3wyKXV+jNK04iLMq797Jkae75wld1kMwz3
	z6Nu2HmQr21YZoqTgQy2Fq1ls2Yluo5rVvs4QYhjdptv1XJEwumTqVA+OJ/oGhwjbWO5sb/IeE2
	dUzskBW8QOLfmYuSAJX/DBE8Izj5haWLrFZ2rpz5y0YIbWLb7H2WSDDcoFGtTElLFn9aTF92AJ1
	RZgFBRecnXRlzHV7IxPxfm23GnpgqW9Dal5k9iWXugku8rF8F98FMcKRQ88Gm0iIXIIGKEkvpU4
	nI=
X-Received: by 2002:a05:6a20:12ce:b0:39c:643e:f062 with SMTP id adf61e73a8af0-3b22e666e6bmr15766495637.7.1779074685504;
        Sun, 17 May 2026 20:24:45 -0700 (PDT)
Received: from yafangs-Air ([240e:46d:2600:5755:6da0:fa04:3566:e6d3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c82bb07d2fesm11721506a12.9.2026.05.17.20.24.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 17 May 2026 20:24:45 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: sashiko-bot@kernel.org
Cc: jikos@kernel.org,
	joe.lawrence@redhat.com,
	jpoimboe@kernel.org,
	live-patching@vger.kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	sashiko-reviews@lists.linux.dev,
	song@kernel.org
Subject: Re: [PATCH] livepatch: Allow to handle lifetime of shadow variables using the livepatch state
Date: Mon, 18 May 2026 11:24:36 +0800
Message-ID: <20260518032436.49958-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260514220757.412F4C2BCB3@smtp.kernel.org>
References: <20260514220757.412F4C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 591AC56568F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	TAGGED_FROM(0.00)[bounces-2841-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[9];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Action: no action

> Will this callback run in an atomic context, unlike the other state callbacks?

> All existing state callbacks execute in standard process context and are
> permitted to sleep. However, looking at klp_shadow_free_all(), it invokes
> the destructor while holding klp_shadow_lock:

> kernel/livepatch/shadow.c:klp_shadow_free_all() {
> 	 ...
>	 spin_lock_irqsave(&klp_shadow_lock, flags);
>
>	 hash_for_each(klp_shadow_hash, i, shadow, node) {
>	 	if (klp_shadow_match(shadow, shadow->obj, id))
>	 		klp_shadow_free_struct(shadow, dtor);
>	 }
>
>	 spin_unlock_irqrestore(&klp_shadow_lock, flags);
> }

> If a user assumes this callback runs in process context like the other
> state callbacks and includes sleeping operations, couldn't this trigger
> a scheduling while atomic panic?

This problem wasn't introduced by this change; it already existed beforehand.
There shouldn't be any sleeping operations in klp_shadow_dtor_t. Maybe we
should rename it to klp_shadow_atomic_dtor_t.

[...]

> Does tying shadow variable lifetime to the global patch state cause leaks when
> dealing with loadable modules?

> If a livepatch applies to a loadable module, it may allocate shadow variables
> keyed to the module's dynamically allocated objects.

> When the target module is unloaded, klp_module_going() unpatches the module's
> objects. However, because the state is a global property of the patch, no
> state callbacks are invoked and the state is not considered obsolete. This
> leaves the shadow variables for the unloaded module orphaned in the global
> hash table.

> If the module is subsequently reloaded and allocates new objects at the same
> memory addresses, wouldn't klp_shadow_alloc() fail with a duplicate warning,
> or klp_shadow_get() incorrectly return stale data?

You're right, this is an issue. We need to ensure the associated shadow
variables are freed during klp_module_going().

[...]

> Can this permanently leak shadow variables and state during an atomic replace?

> Livepatch supports stacking, allowing multiple active patches (e.g., Patch A
> and Patch B) to define the same state. If an atomic replace patch (Patch C)
> is loaded, it replaces both A and B.

With the introduction of replace_set, it's no longer possible for different
patches to define the same state within the same set. So, I don't think this
is an issue.


