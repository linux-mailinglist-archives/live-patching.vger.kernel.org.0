Return-Path: <live-patching+bounces-505-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0723595ABB0
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 05:06:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37D7B1C24900
	for <lists+live-patching@lfdr.de>; Thu, 22 Aug 2024 03:06:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C501CD35;
	Thu, 22 Aug 2024 03:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O/Zeejj0"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7741CD2F;
	Thu, 22 Aug 2024 03:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724295727; cv=none; b=o/ThNcdywwDKzBzBKpp01+IZIJCErUse0yEGu7dQvBvmD/+AbPa+qlXqm9P78IXcVTpTKGd0JsD+pjEeATpo84Ho300SHrOKQdFLPvUPbRRiqyAZKF2fWy70EZBedfQEgG7eXpDzMP3LUux5jAxaMB+RB90ocXOfGgNV+IKH61M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724295727; c=relaxed/simple;
	bh=Wtnn3zs7AeC53NtP/dNDE58k0VSDq93Qsf9ehzuh9pc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=EME+mc4bikox8eIaD8HC25VxaLZ6OAyGB8o+mPOUPykIZFffKbMoTnkIEaO/xVbak35HiT1ctnvDuCNa/xUllCuinmyGinwV9juS1mbw6IbyO1TfwHTWfg12YLz7Owv+kxoEIDXQzL7Ak0GKFsRkQ4jizhSJEdeAgDLXrdXIPws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O/Zeejj0; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1fec34f94abso3180995ad.2;
        Wed, 21 Aug 2024 20:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724295725; x=1724900525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9lHz0GHFM9v5jdmN519R2QrSUIaCEmVgVq7mI6wU8Qo=;
        b=O/Zeejj0kwlvh7EWKxS9w9IaKM/vJ3/BDvkNMFTZnKPY/obJDV4LR2w3q064XFajeJ
         K7hIWMz8zUiYsJvd5AFwlVDXMze+2/AMc42CQC9bjs3NiUSSEDo6K889OjLsLKJ0BySa
         sOHrTOmjgKqffzwK2QwakuTBKt1IUZovCOVV3G5UJEPXsCyGyr2xgdlRDORnvkg7+jpc
         gb1PoGNME6ZN34XqTPQbltbqRUjKvzi/tVlRAbi4ef7xiK3J54m780zz+Tc97cr6U0Mh
         Qu8EnCYku9OauX8x/hd7qeydH1KsVVu6CT22g2bHsDWHc0OwcrrWDP/3Diw6CZeZnx9q
         lhgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724295725; x=1724900525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9lHz0GHFM9v5jdmN519R2QrSUIaCEmVgVq7mI6wU8Qo=;
        b=usQfHskUK8Ubp3/1XFFpMhNI/XgBitknozOsDMAe5Gp4bu3Ap928F5BKolYcLlL5Qv
         X62GRy0qU8XwzvdtFX04+dxhBbw169cAd0uK6/ZY3Canon0fsRmnCX46ujNsuen3mAtD
         eTcriF3Q34/8JFL8Fd8GRh3MM3YlikyEGs2dOT8JdC9AIIu8GXHcni/qkGTVdIHQy4po
         88SOQRk09TN9so8njCXuBt7/b0qg+wqjJeCq6DqZM4dyhivDGeroHoQ8sIIBEKucHBo+
         LfYdeL1XO3xEzGqSKOuMhpJLVxu2KLPwQp7zjPPw0c9ykcOE+7t73pASHhINtAZfSARB
         QO8Q==
X-Forwarded-Encrypted: i=1; AJvYcCWI/uXCFNa9TAa3yO/Mmb3qlrfVyE0WgPGyClwvPITaTa8O0IiwUnDOgquhJS+jcIDmCKAyoKveM1o+TOw=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywsnijxi3c2jZWkVabVisvHOL1NA3LfWmR/dyJS8SSoY/qhF7J2
	SRkL1Kkrq7o1iRyfrFGZ8DM+r1h0dYgW6KJ7R/AeHScNpPnzR/bK
X-Google-Smtp-Source: AGHT+IHmvliNTurI44bt746VArYBUgUEbRQ0greUx2aDSzkS24zLnmxHpjhsa5fDTvEoPgytkvOrqQ==
X-Received: by 2002:a17:902:ecc8:b0:1fd:6c5b:afbc with SMTP id d9443c01a7336-20388b9b305mr6802705ad.49.1724295724827;
        Wed, 21 Aug 2024 20:02:04 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.124])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2038557f093sm2878835ad.63.2024.08.21.20.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 20:02:04 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/2] livepatch: Add using attribute to klp_func for using function
Date: Thu, 22 Aug 2024 11:01:57 +0800
Message-Id: <20240822030159.96035-1-zhangwarden@gmail.com>
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

BTW, I remember to use ./script/checkpatch.pl to check my patches..Hah.. :)

