Return-Path: <live-patching+bounces-2360-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJGuAoyo4GlZkgAAu9opvQ
	(envelope-from <live-patching+bounces-2360-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 11:14:52 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 62B9C40C0BF
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 11:14:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 92B56301443C
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2026 09:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62CFB390C85;
	Thu, 16 Apr 2026 09:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="aCxCJWbS"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F097D38BF87
	for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 09:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776330860; cv=none; b=A4Jix6QlXEhWDf1l9GuTv+6RKl172AEVqZhD5M5RclaG2k8K7Ugj9owlhIwgrl61IJlNd9sxz9CXAUxRWC+FQ2JTxCZcFvF2zryYUbEDVQ4ZGY4abKnqoCHogRSyRKLvpqfIvVpA4a1KDToY7zxpNKg/c9l+Qb1RnbYoJozIgww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776330860; c=relaxed/simple;
	bh=5ckdpmX3oxdkRbS40J4TZb3lH8Jbj4z+z7MfNMQEHds=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=P9mCnj1NSEFFW1fL9e60tsfPOxinVyzoY6FXSs72snZzbUlTlsL3E6Z22gsu+vZ8sCnbEQ38XTQru3QJ33++vB3NpJnY6upVfh4aEugDBtg0XZQi+2NGDe9E6LPeDdkV1Pik6tEL4jQUDhk0NV640dC2kkA9W70sg+3huvdAIcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=aCxCJWbS; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488e1a8ac40so72702215e9.2
        for <live-patching@vger.kernel.org>; Thu, 16 Apr 2026 02:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776330857; x=1776935657; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lili5uj6lyb2P/Kw1BQmhKlCW/j+EjLGa+eg4urlGBw=;
        b=aCxCJWbSxWhVdKyDJ+Ng9Xcm/dT38w3oP/QFaOTAuWEhhBl+/00W9hiMcYl5oj+lDX
         kFPcE/bcZYoDDYuWrDQxvoW2+onoNpsoPw8WirG4vOeZ4qFPZj2ytb2htk2SN49J4I8b
         NFz1ZFEkXQKmXv7POIbXYNEiz4Faamq2bhgmXju7FeC+cXsewtfeR/Np0qCQZa0OtsQP
         9oBAq3G3uG5Egp/xb7p812kd1X+NgoXHsaPxPUdoPSEjlqFFqG+sPNbObjEkqKi3prlH
         dMaZt7uWckB2uGvh7b/2me6/VMaiQ/fHAZf1QZHrncyT5/8IUjFqLBsdJu6U/qQEHoWR
         J4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776330857; x=1776935657;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lili5uj6lyb2P/Kw1BQmhKlCW/j+EjLGa+eg4urlGBw=;
        b=LVV9Ck5/x3c/TYF2jySt6YMPoCQBTGfrEnXJuuARvwM1ePoo4civWntmcTSW/BRzCK
         KjYLRMjkBR3riHjaNMvokF23jvjSuQTa0I6Waz06zdnr+n9uPGyEdrcqGRTiiVLaa5p/
         7seeWI60Q7o+cl7iwe7pHhD15drTtbA6AJ/9ObLt9aIPS5XxoIYquVCxRLBHK5Y53UE0
         s78ajskntsxaUduJU7LdXdcysWiLNz7lvm1jrP7YuACLZg6Sm1psYHF/7vfKrDHmjSKC
         MX61dI5sBouCjFXeJFLG+1V5NneSI+OBhDwTy3un39hi8meQoVOSDhVwk6sB3ymsaNxG
         nsBg==
X-Forwarded-Encrypted: i=1; AFNElJ+vxyIu2S6wWRYxpF90n54zSd9Y1it+gJ0aU4ko82TPdie5m5ULXzZbecVou2v7yFa0J8FvtrqbY9zw41FL@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4+yF7jU/A2N1fQ7EIdvncwWSGDwftdYOvgIvIP6FyKbCgKL+D
	vrBgqiRq8cIQKCYJtWt91u3qxvYmm9N3l+DnZE7zVGaI1i26TmUu+QfuN9ova7lg+1k=
X-Gm-Gg: AeBDieuyyrEshdvT6yMzz3KxPTRc6o1OwvGSkXw3L41oEV7ML9G6mRoskzPkyjpjWEW
	DLBNEhIIM2y9saAgtjsEA2Deus4wJ7yp8ZkWktRg1snN85bcCcbvEKGWlmwJSvVcTvmwEMv+njg
	ScU90NJveglsn7w+Y5/leDMSNJPd9y5ouMxPfhP+t6QZjhItcUJzfx5WjXJ+YMxNobPDVa8Syhz
	wrCwRwwLf5TKKooAEwPrMMLIo+ErqdkdKh6tnMVbqB5X9F9SXUdU9FfeXh5aITgDbHVA0X7tXgh
	qmJCpDrHqZ/WPogSDVa8J/eCzT1JBA4tzqKEnluQZGSdaHye+4cG3Qiu2FQJgD/SX1YBOf/4Cvz
	+9yoX13HSJ1SCCkaxwRQe8gKJuggPcEZOT83scJ6RDdUWEEcVx4bFOFHvMKr5sJ2824DbOm+jdM
	a2N7QaLmQkAnD6wbZu91Dxca35FA==
X-Received: by 2002:a05:600c:5299:b0:487:1fb4:7e1 with SMTP id 5b1f17b1804b1-488d6875f3emr335830485e9.22.1776330857239;
        Thu, 16 Apr 2026 02:14:17 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488f5827e83sm39876105e9.15.2026.04.16.02.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 02:14:16 -0700 (PDT)
Date: Thu, 16 Apr 2026 11:14:15 +0200
From: Petr Mladek <pmladek@suse.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: [GIT PULL] livepatching for 7.1
Message-ID: <aeCoZ4GkkSzOLA68@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_FROM(0.00)[bounces-2360-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,pathway.suse.cz:mid]
X-Rspamd-Queue-Id: 62B9C40C0BF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

please pull the latest livepatching changes from

  git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git tags/livepatching-for-7.1

======================================

- Add two new selftests.

----------------------------------------------------------------
Marcos Paulo de Souza (1):
      selftests: livepatch: test-ftrace: livepatch a traced function

Pablo Alessandro Santos Hugen (1):
      selftests/livepatch: add test for module function patching

Petr Mladek (1):
      Merge branch 'for-7.1/module-function-test' into for-linus

 tools/testing/selftests/livepatch/test-ftrace.sh   |  36 ++++++++
 .../testing/selftests/livepatch/test-livepatch.sh  | 100 +++++++++++++++++++++
 .../selftests/livepatch/test_modules/Makefile      |   2 +
 .../livepatch/test_modules/test_klp_mod_patch.c    |  53 +++++++++++
 .../livepatch/test_modules/test_klp_mod_target.c   |  39 ++++++++
 5 files changed, 230 insertions(+)
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_mod_patch.c
 create mode 100644 tools/testing/selftests/livepatch/test_modules/test_klp_mod_target.c

