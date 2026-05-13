Return-Path: <live-patching+bounces-2799-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJn3GWiNBGoALgIAu9opvQ
	(envelope-from <live-patching+bounces-2799-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:40:40 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2510C535459
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 16:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DC149305450F
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 14:34:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8258A44B692;
	Wed, 13 May 2026 14:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IR13dfhu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDD5243D4E2
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 14:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778682842; cv=none; b=pnPHOxArHofz9T2mqoR4ZaGttSO2UFLv0yZgNHJpQn+68QIlV0Oo8ZcI1FEH8gSzxwBICTRZGdw1D4D4lXKh30JjRlUNR2JoBcISmd+cpB7e0T+rCXbDrDILQCD9rsh22swHJS+3H6nPRH98ckJuMF+3Ru9eRnPE9/eR923oQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778682842; c=relaxed/simple;
	bh=dfKQebfvYV01n9BDLdP2f+gl2OpzJB0nHQBKtvWOooE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p8y2nBEUH0B+MSxzPEZer3U44x+fdQf7g10pUaYj/oMPVCvpnzPxvXIUENtYIPOj2g68pA4JWPRRz1LQtJ1tCp5vwIahfYpsJo/8xrlTeKvvw+IJl/dGCGx9zTpQVdyVGWQBbc7Q+dmYfjoxtuEDVB46dkxsZpc7J9syHZV4/QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IR13dfhu; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c80167f5716so3030134a12.2
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 07:33:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778682835; x=1779287635; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9NCRCgC4R1mbMwJy1J8zzCoALIh6Y1cOjVOSf5s36zI=;
        b=IR13dfhukJ3UXr+Doq4bXdKWcQZNXXz4ZbLmR2uySM1i0bN9hU93y2jLKtWg8wanHh
         AP7aFeFEs/TZPdJnsUk7nx9x1+8Yl/xn4ZujU1Xtv8H6XXle0DUMNTloAnPuhpF0caYh
         nv1DxqEYu3K2iayIZYiRIDufnTtqqg48BqXOoNbEgQui1qgiMHT5nlz2JSnKEfTCwo+h
         u9PJr6gtdtUoitaFl95guaGz0g6qVrMPLL3+L32MFh/p2tFwUHkt+cWCWnqMXIa6xXBd
         opU0P1pr3EaEZpOBpKGUQcXBYdY9jJUCezNt1gaVqNtamcoHWLcpUMn/NVBxf55ipG/y
         5epA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778682835; x=1779287635;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9NCRCgC4R1mbMwJy1J8zzCoALIh6Y1cOjVOSf5s36zI=;
        b=OXH7LbICDLpwklkXLU+j5/MbsuAlZm4l112wc9DxAzKes4HAyTH23YENY2kAFfmzb+
         4knFaxeGWi2uVQ9hyHVWZ3VR/r30QJtwlY/YeH9w7wvQXAagDniVe+x0thLK196/r87n
         orfZHwLyrW3dXPAqhAfC0XJCOOgl7NK5+xuffDmYDCFVdzTSel831ySn8U6cldchcZNg
         jIcJEx2Nibh9ySBv9Kua+RKB1/qb3P6brYnzStA72VG5ERlGSjoRnDCJh8JhnbtML09G
         4Ml5rOD2gPFgIMwlQqpyvLl6FLpxaT18ilBTfOLuOthgDYrgBCO1lkv/9EUP7B94+WaJ
         bE/Q==
X-Gm-Message-State: AOJu0YwNsLVosciyL2p/Q6aiAmPqErNbwuhdv8m6HMDXwA4bXSylnbKe
	dL9V+qdfxKU40mL8kvNGzwJrXEX8pDILjwFOw/0cJB97F6mZ4MtDkQ1t
X-Gm-Gg: Acq92OHQ/mHXnnV2aFN/AmnkyM5f88eB+EP5Jtr1zL+B0CTRYxHgaJNyux8IUAUTjld
	tEoYiEFDMXizPnIUU8tsg8TSnRXM2WD5s21ik97/9ysn8ANp7lGAnAm7FL2vzL0Hb2N9l/RHotW
	YllyBQqhvMXAnDQSdIT01dtRP+NQQ3lWcmXBtyiteSiJ12552CNiS1TpUDOKTXInf8h0nFMbepe
	NDEo79jXMKPhKKX3eVdLoDuKaepnMXXZdvXsauJoVyjcs5AFuN9Yc+K23tOBlSn9Ocutq7KfY+o
	2Rtxh6M9EJGcKxajRIpy2OYIdnWS2YWAbWHGB4FHcq1S6WNCyzYhKj/qZzBB4q50t4ahWuDcbc9
	oYUzIFQ4ZgJ7etvzWbGMWNqRNAud+yT2+VeNbLCwA3a/rRLoiw1oT1PkePW4et6QibTh8Dp6aer
	fT0wv6+wZICBfzr08p3ONDnAG5CdIdYku74IPSfzENCuSXgDCHbBmIQY+5NRRoYYuNeJ3TyJd/O
	N6wpZ9b1KCb1vE=
X-Received: by 2002:a05:6a21:3299:b0:398:79a8:5bf4 with SMTP id adf61e73a8af0-3af8197717amr4167777637.37.1778682835023;
        Wed, 13 May 2026 07:33:55 -0700 (PDT)
Received: from localhost.localdomain ([240e:46c:2200:3c3:e555:e58a:71d1:ef1d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c826771018bsm15006418a12.17.2026.05.13.07.33.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 07:33:54 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com,
	song@kernel.org
Cc: live-patching@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 0/6] livepatch: Introduce replace set support
Date: Wed, 13 May 2026 22:33:15 +0800
Message-ID: <20260513143321.26185-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2510C535459
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2799-lists,live-patching=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Action: no action

We previously proposed a BPF+livepatch method to enable rapid
experimentation with new kernel features without interrupting production
workloads:

  https://lore.kernel.org/live-patching/20260402092607.96430-1-laoar.shao@gmail.com/

In the resulting discussion, Song and Petr suggested adding a "replace set"
to support scenarios where specific livepatches can be selectively replaced
or skipped.

- Patch #1:
  Adds replace set support for livepatch functions.

- Patch #2~#5:
  Derived from Petr's original patchset:

    https://lore.kernel.org/all/20250115082431.5550-3-pmladek@suse.com/

  All the selftests are not included in this RFC.
  Note: Due to a significant refactor in Patch #5, I have omitted Petr's
  Signed-off-by for that specific patch. Please let me know if this is not
  the preferred approach.

- Patch #6:
  Adds replace set support for the shadow variable API.

Petr Mladek (3):
  livepatch: Add callbacks for introducing and removing states
  livepatch: Allow to handle lifetime of shadow variables using the
    livepatch state
  livepatch: Remove "data" from struct klp_state

Yafang Shao (3):
  livepatch: Support scoped atomic replace using replace set
  livepatch: Remove obsolete per-object callbacks
  livepatch: Support replace_set in shadow variable API

 .../livepatch/cumulative-patches.rst          |  17 +-
 Documentation/livepatch/livepatch.rst         |  23 ++-
 include/linux/livepatch.h                     |  30 ++--
 include/linux/livepatch_external.h            |  62 ++++---
 kernel/livepatch/core.c                       |  51 ++----
 kernel/livepatch/core.h                       |  33 ----
 kernel/livepatch/shadow.c                     |  70 +++++---
 kernel/livepatch/state.c                      | 165 +++++++++++++++++-
 kernel/livepatch/state.h                      |   8 +
 kernel/livepatch/transition.c                 |  29 +--
 scripts/livepatch/init.c                      |   9 +-
 scripts/livepatch/klp-build                   |  14 +-
 tools/include/linux/livepatch_external.h      |  62 ++++---
 tools/objtool/klp-diff.c                      |  16 +-
 14 files changed, 373 insertions(+), 216 deletions(-)

-- 
2.47.3


