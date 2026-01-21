Return-Path: <live-patching+bounces-1913-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YFwbN6GPcGkaYgAAu9opvQ
	(envelope-from <live-patching+bounces-1913-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 09:34:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 898E953A49
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 09:34:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B9A003A1145
	for <lists+live-patching@lfdr.de>; Wed, 21 Jan 2026 08:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 853AB3A89DF;
	Wed, 21 Jan 2026 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WWBRKCkN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53CE3624AB
	for <live-patching@vger.kernel.org>; Wed, 21 Jan 2026 08:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768984160; cv=none; b=HFrFd8RbSiyrwbPUAKz2RLkadRrUF5/U5lBG1882sQc6euPzM0t/YGT2dlbKg4W/6lQ7trN798TTuc9+lvQZaPPhFJFz7SS+u/J6qYDeWHV217ib2Fn61WdwxO5sBafjYcJMEK7hYfeBh0W1iy499CvEhnXOm4ASJx0MIHJEn1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768984160; c=relaxed/simple;
	bh=M73mSeNlCdDSDOr8x2qVL/sHZIW2D8gEAgivQ+HV1Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ug6mvqf6GT6Gi1X3Qfeupad15hGRiCyIt3Dbi9KwnzEUMD42Ne3JDiGwKxKFOkqhybFzbJvT6SjlXUzA0IqfVIN5ubVGwKC5MK/Vxs8jeAm51u1cRVkqNSwDQWHjVEc+9jEELuPa7oWLQn26KHeXicp6K+eb6OZUVGl34whXZno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WWBRKCkN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4801d24d91bso44977805e9.2
        for <live-patching@vger.kernel.org>; Wed, 21 Jan 2026 00:29:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768984156; x=1769588956; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rokkUlVHndrZqjIFjTr/DrX1NCRwQiWmE6h5JFa0Tgg=;
        b=WWBRKCkNM/u1zKnXQC/VQTGGG/E8uFyUz5es89LzbACxqaXpRfIGEWTG7Ms5+3J+N8
         lyMOw5/rmhm9QVKettdtNLD6MDMnzqq11g+5y869o8kaEis3Z+28Y55C65kdraBdXXAc
         SqxSWjSgqX/+pn1CwzkhnDoPTXe6IvbddhrQiRG3Vlxnp1zyWm8reRRZcNX8kLta9LWs
         tW5aaHiZldMkaNaPE0sPqIoXVMGQXidCIgE3aQFUd0VWs8EdHz4e79BqHpr/ppzAGme+
         +GTwZMsvotfNudvnwkax8I8l9vHfTKFhCmoJQvewrYdzNoj3H3e+opcpqTe+wgCgDeXw
         AdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768984156; x=1769588956;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rokkUlVHndrZqjIFjTr/DrX1NCRwQiWmE6h5JFa0Tgg=;
        b=Ug1CkPvuj2a74wJk9d+MZpjB/r8XcuZ9h2PdTYAleQ73uqqNt3V0Gn0R9N3dNQrF9P
         gtejl2bzK7MJUAKd3UGDygp7BzivG1FMFkaC3i7F1bWUBo6gsmtdhPdB+nU5eoMG1B8j
         LZgQgcXUaf+vgxnNcltlvgOFURU308cQpTnPm30R0tXgHjKO+dvXIe+SOR8wH7SynvHp
         UjsETdmOHNqvinwnZpdFtlAa4XRmtqzQ2lYr+BJDH2/8YM3jRCv30nLBIWRF40uGlE6M
         ZtgDivoGyQZte7WPYPXuUNwIRwbfpge7W5cxXlj7h4pOGw+dNQGBpLrMaBgEEOZ7b0sG
         nrCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEg7nv4G+ztWqIf8bXmlydKFEMMQTdOyFXGsOT1t8Ybru3WXMu1YYYJ1kfikj35jBNO5fscYRv9DuEvTtA@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+qnB+00bwlu8YAfOU9ZlUptqrwHm5UDO3RA0IX5u8SXiKo5LT
	ttYBTZ84WFbExfOdlmDdXm3fUmGagrRgFdaCmTRKRaXO7GXLZgPpGB80qeYqjapLGoI=
X-Gm-Gg: AZuq6aJfZJhOv5cNAPpLMXAqIYsRmfVWz88uIOLlfAMUZLMU7aLOdrBhDMMJUz7UM++
	IFUzMbhxRi2YRe09mQTPqSXW0MGmVM2zRNoKtgkT1+KLWY6nHNsYkbqzxAzrgTc6YOliFhziAFe
	NJCkBN3tBLEvxne5EYW+wlRrLQcWenszhCh0flXt1nqxc6Je356H/UCqOqsZejP1EBMbni7ywo0
	eMoREGFZGZI92s36wao4Bxuo1RkDnhWK2pIdAxmg931A+79LsXnssXnB8bM99TSRBMkrHl0/FV8
	teLxJoFSakKGHOyCN4pqi0gHtYCTxXDCpdYnPWFXndve8Iku5QyK4hgOaRTxHcrp5NFZ0sgd+K/
	kScaJPixbeTiJH7ZnQby3FCQmjxT4C+o3FzZRKQSwu1H+WizgyPpNomJ4RnC8uVOlK5Ajp555gW
	LXSSiqpEpfrbwRxSlltTPm9wg2otdrmFc=
X-Received: by 2002:a05:600c:a03:b0:465:a51d:d4 with SMTP id 5b1f17b1804b1-480412ed37emr48490635e9.6.1768984155839;
        Wed, 21 Jan 2026 00:29:15 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f4b2755absm441635355e9.15.2026.01.21.00.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 00:29:15 -0800 (PST)
From: Petr Pavlu <petr.pavlu@suse.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Peter Zijlstra <peterz@infradead.org>,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] Improve handling of the __klp_{objects,funcs} sections in modules
Date: Wed, 21 Jan 2026 09:28:15 +0100
Message-ID: <20260121082842.3050453-1-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	DMARC_POLICY_ALLOW(0.00)[suse.com,quarantine];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1913-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[live-patching];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 898E953A49
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Changes since v1 [1]:
- Generalize the helper function that locates __klp_objects in a module
  to allow it to find objects in other sections as well.

[1] https://lore.kernel.org/linux-modules/20260114123056.2045816-1-petr.pavlu@suse.com/

Petr Pavlu (2):
  livepatch: Fix having __klp_objects relics in non-livepatch modules
  livepatch: Free klp_{object,func}_ext data after initialization

 include/linux/livepatch.h           |  3 +++
 kernel/livepatch/core.c             | 20 ++++++++++++++++++++
 scripts/livepatch/init.c            | 18 +++++++-----------
 scripts/module.lds.S                |  9 ++-------
 tools/objtool/check.c               |  2 +-
 tools/objtool/include/objtool/klp.h | 10 +++++-----
 tools/objtool/klp-diff.c            |  2 +-
 7 files changed, 39 insertions(+), 25 deletions(-)


base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
-- 
2.52.0


