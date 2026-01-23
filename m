Return-Path: <live-patching+bounces-1918-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2NehNWRNc2lDugAAu9opvQ
	(envelope-from <live-patching+bounces-1918-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 11:28:52 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D9C3E74522
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 11:28:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 02D4B3006085
	for <lists+live-patching@lfdr.de>; Fri, 23 Jan 2026 10:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FE51364025;
	Fri, 23 Jan 2026 10:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DfgiVAmQ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2109F30CDB1
	for <live-patching@vger.kernel.org>; Fri, 23 Jan 2026 10:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769164125; cv=none; b=upsehMsQ24UUEYiwnyEwmQnaPYJuPk7tOmZ+4Ca/GuipUYxioOZeEVvz/amXs1WZG7BDxtHrUz3gr9dh9nDiLAU//Efo220os/qsxeGrFK6rPl9SDr+J4MkPXukUYbGfgdcgBtHmKIJ14gs6YLT2HnBEKVBmL+58s9BkhpOFAQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769164125; c=relaxed/simple;
	bh=vZ1mu8tSLKnZvZCLHWhAzIgA8g1lboSmvVDlNeb88nU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Yoz67e0GXVvlnj3ewQy8FCi6/kH47bFa3sz84ppkCItGfBIs1QVmDks89xDtyAs4/GMt7RjfvC8J4ct+6HU4o720yBd6yH6yTaIKm8ACQZN0JEZTGvjlVbmzMooa/PnvF6mPxGpX82+eHBV/zAVV+7WUuJW2U9jbY3mMuWGgFUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DfgiVAmQ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47ff94b46afso16189915e9.1
        for <live-patching@vger.kernel.org>; Fri, 23 Jan 2026 02:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769164122; x=1769768922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tCADJuO9Wbmf06FkgoP6KGJu7f/7b8t88gQaAJJ56KY=;
        b=DfgiVAmQminUUCfEvpsFyzML3DK4bjplmr4NhZ8cIxAeFR9WAU8/m7k0qQtOhSjgfu
         HFwWmAwUMiLVaqfmVHWm7YDMlglJNKy6bh1yfM9Vx2VBSsLp2mqkyck6zBvMPgql07Pg
         eD0r+rXREcIbhPUd6JfRy/OMFd+0ReUuYgKa9ALSx3WUEnjJM2dkTYgYQfF9rpA8XI/Y
         KVLb2jqRtfmF0V5rWvpHi5F7Atax6T6SqzsOuHPDrsRdfoEs9r+5XZcFGyCkcevm18M5
         REFMeHji11/pRGuVm032f/Av/q0dFoCLuFhE74YxasPt5mYcfhjBJx9vnrTNR6CtPRzH
         81Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769164122; x=1769768922;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCADJuO9Wbmf06FkgoP6KGJu7f/7b8t88gQaAJJ56KY=;
        b=rmDy9qWI4+/+Da45cwDyZfRdibZe57x1Qe660FoDMNp8rSaooule873ZsiIswW+jqT
         n46nJqCEuFck8bXL/dhOvWbmGXzDvvTU7BTCWQCrQBhzykwMLghjyOPZnyWttmpP89NN
         ohpeMnm4Q5PbycGU/TjxK/KxTJp714PAuCGwqWf3drSfqJbxpiOAbU6eUmYkerN3IjAT
         OnfbEQEI/RQ6L1z4UR1dm+OjRjNpS65khEgftc7Y2RJfWr6pXW+/XSxFcPpQdlENlh6/
         oxvKg2b//ku93su3X4rQ4jAiqnHdHYGoyY1K+oGhp4GDFD+lzsAat8nhyCPf9nOt6ONY
         EBQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0Po9PfQJE0zaRQetMeWe4Dr13MkXQ8n+WBbESeHZO2wLs10vsA4cenLXsok9W4WhxXNiPEMOw3ksrAP9N@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr6bWV34zxW9WBWeVMmJMVtKWPMmyTT+/ndN/xAmaMe3WUzXjH
	ga1/UltKG/3ghTG3d9rkAdp67MIo7TWVk+jk4cX+4u1GPrAPuxp2EPrw1/1diTGB2Tg=
X-Gm-Gg: AZuq6aIfax6uOdrjq3pFwE5e/0QhFRdrFG3ohlxXKFAKx4BTXpcG+2V8YGh5PUndSdz
	d/HK161GfInQP566bJZY/UP1/YL4i+J5nlRhcLLTUVwT9/zOP/9lfffzFEsLXF3wfVu1SfacJ6j
	DTzuCvH88itQwQmKLXFCxIYkVWksn/S65yzqUDKV4j67DMS14aufFDhRhxYWDMxVPd6Q6i24vNp
	ge032KEsx/q7cnKW84CSyIioD0CeqAIt89fkxQJrOElgeFosuSGA9UtXy9kdiHOtI4RWs8ElTrb
	nwvw1XYU3d+VZBPRJFRewb1sP9j0Qr7c7MyeGHb8t4E5X43i6qnas61PNLcZsktYQwZXuL+YRnS
	kC3mAx73wUQz/ou1YQiCjdmdIvAC43O4qb9qIZvLmu1V7SjYk5fuovUypD1Z7FE+y4NjG6joLJO
	UDajojyFt2FY+RVHRtn1VhEZbPx5hw/vOvJWJ679oOTA==
X-Received: by 2002:a05:600c:6994:b0:477:9890:9ab8 with SMTP id 5b1f17b1804b1-4804d2b1704mr36414875e9.3.1769164122581;
        Fri, 23 Jan 2026 02:28:42 -0800 (PST)
Received: from zovi.suse.cz (109-81-1-107.rct.o2.cz. [109.81.1.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-480470474cbsm128920065e9.8.2026.01.23.02.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 02:28:42 -0800 (PST)
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
Subject: [PATCH v3 0/2] Improve handling of the __klp_{objects,funcs} sections in modules
Date: Fri, 23 Jan 2026 11:26:55 +0100
Message-ID: <20260123102825.3521961-1-petr.pavlu@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1918-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_NEQ_ENVFROM(0.00)[petr.pavlu@suse.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-0.999];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D9C3E74522
X-Rspamd-Action: no action

Changes since v2 [1]:
- Generalize the helper function that locates __klp_objects in a module
  to allow it to find any data in other sections as well.

Changes since v1 [2]:
- Generalize the helper function that locates __klp_objects in a module
  to allow it to find objects in other sections as well.

[1] https://lore.kernel.org/linux-modules/20260121082842.3050453-1-petr.pavlu@suse.com/
[2] https://lore.kernel.org/linux-modules/20260114123056.2045816-1-petr.pavlu@suse.com/

Petr Pavlu (2):
  livepatch: Fix having __klp_objects relics in non-livepatch modules
  livepatch: Free klp_{object,func}_ext data after initialization

 include/linux/livepatch.h           |  3 +++
 kernel/livepatch/core.c             | 19 +++++++++++++++++++
 scripts/livepatch/init.c            | 20 +++++++++-----------
 scripts/module.lds.S                |  9 ++-------
 tools/objtool/check.c               |  2 +-
 tools/objtool/include/objtool/klp.h | 10 +++++-----
 tools/objtool/klp-diff.c            |  2 +-
 7 files changed, 40 insertions(+), 25 deletions(-)


base-commit: 0f61b1860cc3f52aef9036d7235ed1f017632193
-- 
2.52.0


