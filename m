Return-Path: <live-patching+bounces-528-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69684961C05
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 04:24:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C244DB22720
	for <lists+live-patching@lfdr.de>; Wed, 28 Aug 2024 02:24:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AE5481CD;
	Wed, 28 Aug 2024 02:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEsR8AMW"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0458042065;
	Wed, 28 Aug 2024 02:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724811838; cv=none; b=gg0/jnjPaauX+EnIEdMTYjUNkSlDlfpVZ2QF424AAszrtNcSXFULR61GfHKAwJA57pc2D/jKtLSzJR4LPLvDsFs2NuVoiXz5NwINflWjzMRlhe1uJhSrJtCP6KvXb9XeNwv3QWtT0V1ymnZROw5svayUYAjHLoYqzDvcanNvets=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724811838; c=relaxed/simple;
	bh=Zl6yHm2+HHCe7WS/Tp7bzZaMUL85IpypD5ayfuZnQJc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=NynA1wlJjNvHLlqFi7HQE2zMizvK91/ILqfnWKyBkhxDJmbo6+8tlMi0eQiNuvrZPft4NbcM53kitZG7dSoTzeysn6L9mqjArF6SzYhrGqpBNHTazSYL2xG/Ec9fnujoUcp5mQ1R43TAvlPxo40SVOZJWuAnk940/4JlEvr7eF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEsR8AMW; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-7cd830e0711so116660a12.0;
        Tue, 27 Aug 2024 19:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724811836; x=1725416636; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=N0ZnxCLrxpzwU3Bgh8etFVn26ZvWIRTemXiSdaUvU20=;
        b=YEsR8AMWp2QsKvDBRSXaugKWSFVq8oHqmqpIAvVq6dDFrdDl6W8YAYTUC3gKxbSI1r
         gaYLYQRnPnaUXRFleZkBaCrujwwCkcPiLFajpWuBMwbVMTgEIkqjmRbPc3PmI+Spm+et
         g0SBplTLPRmVccuuMVepR4Ewj0GB2QHRTFHOHv0mlvfaoSt5oUhKA2Jj4Mc7K4mvRZ00
         hIaTNNbF2J4gY2ZfRlUVoWR7TZD2rAMNokz7q9DKrI7s37afgesd75uVGbZruZLF83Ck
         78IHP6gufxC7qLfytSiQ1pfcLj9/OnP00NN+JbKEgvT2+eIqQQW7hYA9ywXrtkuHs1Sr
         Cetg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724811836; x=1725416636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N0ZnxCLrxpzwU3Bgh8etFVn26ZvWIRTemXiSdaUvU20=;
        b=iXtSiRx2pX+X2vGHUQn6yEKqkEzk8MaS1XkyXSMX4CUGavHPFASRbYiHj7JnK8tsFu
         jhoGnTpcptVjfKW9N5Gigj0Gr8JbPeVdTZjgo3ZjG2R2ymdxRQYhcwYEnMmFtaunRoLF
         OAsYVH/ROkfqgGt+aZcWtXdLfT/okT7SZa4SBWFWRSSJBXksMStJsNxNlKAtiELqBbWo
         NDXvUoAMCTkORGfN/WJ+prmjhznaizA03fwiP4bsVx2PRtdB381rVMG7NBzm1aPM/t7G
         05uwiYL/xLPSKCDeaqU/4L2pFPAOy2ICyjYc4XUkYbN6zaC8N5q2xp9evSV4vkVupA+D
         1rfA==
X-Forwarded-Encrypted: i=1; AJvYcCUAYh3gLo0qQdejxQp7yamXSlFdHyl62H/PBORx5Ac2tqNH7rpDZPmBQTObSdVo3DsVwb1ZDVApFyHCQMo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU/xDGJ5SXFJdw9H74nPdZdDmMQv77mq3Tp1bPVdQpZ2/KtYyP
	oRo/eBHwtiWQ95qLZjguDDxKlP2Mo9545liW9iCv/bb6rgRQApmv
X-Google-Smtp-Source: AGHT+IHDPe1Xijfq1CRm2/M7KJ+STRjBhAugf5EZShVEfiqn9X6dMBPOtQ6lPpgdVRhcDn7NMCP78Q==
X-Received: by 2002:a17:90b:d83:b0:2d4:91c:8882 with SMTP id 98e67ed59e1d1-2d843c839efmr1086835a91.11.1724811835922;
        Tue, 27 Aug 2024 19:23:55 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.122])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d8445db943sm270469a91.9.2024.08.27.19.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 19:23:55 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] livepatch: Add using attribute to klp_func for using function
Date: Wed, 28 Aug 2024 10:23:48 +0800
Message-Id: <20240828022350.71456-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch introduce one sysfs attribute of "using" to klp_func.
For example, if there are serval patches  make changes to function
"meminfo_proc_show", the attribute "enabled" of all the patch is 1.
With this attribute, we can easily know the version enabling belongs
to which patch.

Changes v1 => v2:
1. reset using type from bool to int
2. the value of "using" contains 3 types, 0(not used),
 1(using), -1(unknown). (As suggested by Petr).
3. add the process of transition state (-1 state). (suggested by Petr and Miroslav)

v1: https://lore.kernel.org/live-patching/1A0E6D0A-4245-4F44-8667-CDD86A925347@gmail.com/T/#t

Changes v2 => v3:
1. Move klp_ops defintion into linux/livepatch.h
2. Move klp_ops pointer into klp_func (Suggested by Petr)
3. Rewrite function of klp_find_ops
4. Adjust the newer logic of "using" feature

In klp_complete_transition, if patch state is KLP_TRANSITION_PATCHED, we can get the 
function's next node. If the next node is itself, that means there is only one function.
If next node is not equal to the current function node, the next node "using" state
can be changed into "0".

Changes v3 => v4:

Improve the commit log of patch1. Add the reason of klp_find_ops change into commit log.
(Suggested by Jiri Kosina)

BTW, I remember to use ./script/checkpatch.pl to check my patches..Hah.. :)

