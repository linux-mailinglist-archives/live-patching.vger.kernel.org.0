Return-Path: <live-patching+bounces-1057-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EEC1A1D0EF
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 07:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A725118865AD
	for <lists+live-patching@lfdr.de>; Mon, 27 Jan 2025 06:35:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DCD6146D40;
	Mon, 27 Jan 2025 06:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YymBvW1d"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938BAA59;
	Mon, 27 Jan 2025 06:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737959741; cv=none; b=J9uX17MeDxATKSqFwI6WVaaVRi6paFDnqKmY6cVpWRlXDkRyVSNPQ1tWIYdHV6WJdiuIf0mHZXLGcIafQNMfeT4V4qNbTLKcGyvRbnFygDj/2GjW6dE/2mi21t8f9ndZxo2lQzft57HyVW08TZICirJ9WudM+7B5NPBCP31p/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737959741; c=relaxed/simple;
	bh=MnfIPB47SZVgy1VV8AmtVlPth8BMMrkSLTODFiRsh84=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CNBtZHdzm2PH/Flw4jfRAOGcCXC4hUjrLJ/JOn/n06+tCpJnL/6TXqh+cX+oOeltAxeTaB2Q3tfF65BuAdJXq+AhLsai0ohl7tRdPklEwxj9eY4ROtxBja64KQp2auAvKFbzq+AIbItWdq2EISUOUUpHfPhhxns6fb0kq5JzTpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YymBvW1d; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2161eb94cceso47332705ad.2;
        Sun, 26 Jan 2025 22:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737959739; x=1738564539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N7K2zD6ktQKGfO2mZgXl0sxyTvfZZcGwMPYY1n95/+0=;
        b=YymBvW1diU9vCG0N0Pr8AfPQN5rUCn4d97jBSQOd+Uv1antHUCZPsM08TxrV3xpGOH
         5YUeMFTqYR7kSRorJrQc4BPK5qq/8jSDnDqmL8t7edKcIg+bQLzYi/u6oPfqKkiPziBR
         OfeLdF/pzxOFgvgLzCWsOwebprA4qVSzj+pc50bKteAAabV58sbjX6jdZaGMqx/gzBEZ
         Eyfl6w0m+zzX16vg6xOjNXKqChY0smx7VkKMWNsd0BVdWeVNclVgchvftu8PFRzBsmMY
         GGV16P6krRlMOdkvp0AW6xVTXGbSqgqUAIgetGFp1CVwoDH0eZcCIdsS3Sg7AP8cV3T1
         tGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737959739; x=1738564539;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N7K2zD6ktQKGfO2mZgXl0sxyTvfZZcGwMPYY1n95/+0=;
        b=lYzyjgqbs527/+tmKNeqtKaUCgoxYAjeIuP/X/CiO4QkoBA4G88ELHye7zj3vZPhXt
         9Ro5GMpykr+DkRt2X/+heslJezsJdWXOd62Uas6Xm/twMJN0cImJquaVmkdf/m+2OT6y
         bznsXj7vrMGT8M2/yqO4o6tGStZthdEoODRPuytsdy0OYeEflBDyppzS0aDCsw3SPKw9
         vs35PcfAFNebbhiBNiMZODtScUd8hssyJ5NzLenka/TjnyOOV4ABE6YFkdj8HFictokC
         wpN44h9gyRtcsGlWcUgl8E9zhvoUf5qavtSieSPcS/MxymqeBQEt53r1CbrCFP/DrVCY
         +zZg==
X-Forwarded-Encrypted: i=1; AJvYcCVy2uMlYAydikVWGDGr9Ugn1ybPauzXib6KbhH2304TS2imQ6k9EEYUOgzkfSLMhhYMm1VqCpNt+LwYw0M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbZwMS9Bo4etlxEn57x4ClkdVYc7nPHBsivjlbTBp+JEy3/S5G
	jedV9BkBDRaxrAUW7fiTLJ4k6lr6eAQIczyLuaNWn2BBpmoDd7WCvXbX4SH4Cc0=
X-Gm-Gg: ASbGnct2/8kIqBXB8+Q9ov4VLMusW80bGj9ksqQEb7gi1cUiCoV+7IazAMFq88IHFiG
	BWUhEKfXsaydj9tawGDbfGLUb8CV1y2Z0SwqojrusJecIhVaGZUf4ntvTNJ5liiOerxmaxZ73qa
	anIfedBaxkRh7ROdSOLFnQOKnC7qYqYf9ZDifA2ETpHTSx/9ZQ1ruOhtjFihT2RQignbMSHV5nT
	WD57vJJeKYplApqCNkgnyAP9bQ1VfDA3X1SO7wScEnyrRXqqTPXG+yG1lYTtO7lhF0FxaSMZX0L
	VyZeQE3CFEJjKQ2r3orQvcLPzyE=
X-Google-Smtp-Source: AGHT+IFey65d5Nw1lnnXFI24u5ajs/fLh8Qa+ULix5vcWjvKeBS2VxzLMxhvqUUstAYBN1vqCfvAZQ==
X-Received: by 2002:a17:903:120b:b0:216:1cfa:2bbf with SMTP id d9443c01a7336-21c355deb5bmr654356495ad.35.1737959738724;
        Sun, 26 Jan 2025 22:35:38 -0800 (PST)
Received: from localhost.localdomain ([58.38.78.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21da3ea3076sm55875605ad.68.2025.01.26.22.35.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Jan 2025 22:35:38 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: jpoimboe@kernel.org,
	jikos@kernel.org,
	mbenes@suse.cz,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH 0/2] livepatch: Add support for hybrid mode 
Date: Mon, 27 Jan 2025 14:35:24 +0800
Message-Id: <20250127063526.76687-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The atomic replace livepatch mechanism was introduced to handle scenarios
where we want to unload a specific livepatch without unloading others.
However, its current implementation has significant shortcomings, making
it less than ideal in practice. Below are the key downsides:

- It is expensive

  During testing with frequent replacements of an old livepatch, random RCU
  warnings were observed:

  [19578271.779605] rcu_tasks_wait_gp: rcu_tasks grace period 642409 is 10024 jiffies old.
  [19578390.073790] rcu_tasks_wait_gp: rcu_tasks grace period 642417 is 10185 jiffies old.
  [19578423.034065] rcu_tasks_wait_gp: rcu_tasks grace period 642421 is 10150 jiffies old.
  [19578564.144591] rcu_tasks_wait_gp: rcu_tasks grace period 642449 is 10174 jiffies old.
  [19578601.064614] rcu_tasks_wait_gp: rcu_tasks grace period 642453 is 10168 jiffies old.
  [19578663.920123] rcu_tasks_wait_gp: rcu_tasks grace period 642469 is 10167 jiffies old.
  [19578872.990496] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 10215 jiffies old.
  [19578903.190292] rcu_tasks_wait_gp: rcu_tasks grace period 642529 is 40415 jiffies old.
  [19579017.965500] rcu_tasks_wait_gp: rcu_tasks grace period 642577 is 10174 jiffies old.
  [19579033.981425] rcu_tasks_wait_gp: rcu_tasks grace period 642581 is 10143 jiffies old.
  [19579153.092599] rcu_tasks_wait_gp: rcu_tasks grace period 642625 is 10188 jiffies old.
  
  This indicates that atomic replacement can cause performance issues,
  particularly with RCU synchronization under frequent use.

- Potential Risks During Replacement 

  One known issue involves replacing livepatched versions of critical
  functions such as do_exit(). During the replacement process, a panic
  might occur, as highlighted in [0]. Other potential risks may also arise
  due to inconsistencies or race conditions during transitions.

- Temporary Loss of Patching 

  During the replacement process, the old patch is set to a NOP (no-operation)
  before the new patch is fully applied. This creates a window where the
  function temporarily reverts to its original, unpatched state. If the old
  patch fixed a critical issue (e.g., one that prevented a system panic), the
  system could become vulnerable to that issue during the transition.

The current atomic replacement approach replaces all old livepatches,
even when such a sweeping change is unnecessary. This can be improved
by introducing a hybrid mode, which allows the coexistence of both
atomic replace and non atomic replace livepatches.

In the hybrid mode:

- Specific livepatches can be marked as "non-replaceable" to ensure they
  remain active and unaffected during replacements.

- Other livepatches can be marked as "replaceable", allowing targeted
  replacements of only those patches.

This selective approach would reduce unnecessary transitions, lower the
risk of temporary patch loss, and mitigate performance issues during
livepatch replacement.


Future work:
- Support it in kpatch[1]

Link: https://lore.kernel.org/live-patching/CALOAHbA9WHPjeZKUcUkwULagQjTMfqAdAg+akqPzbZ7Byc=qrw@mail.gmail.com/ [0]
Link: https://github.com/dynup/kpatch [1]

Yafang Shao (2):
  livepatch: Add replaceable attribute
  livepatch: Implement livepatch hybrid mode

 include/linux/livepatch.h |  2 ++
 kernel/livepatch/core.c   | 50 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

-- 
2.43.5


