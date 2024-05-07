Return-Path: <live-patching+bounces-241-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9858BD954
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 04:17:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57ADF283E57
	for <lists+live-patching@lfdr.de>; Tue,  7 May 2024 02:17:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A48434A3D;
	Tue,  7 May 2024 02:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1DxZjec"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5704E3FE4;
	Tue,  7 May 2024 02:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715048252; cv=none; b=KAprYBjtlzb7DlO+LMA6Fdr2MSp84N2Sngh7SRj01oGlQEbGH1nNppXBQCPGnZ4ObUnB3h0g1BOU1uPQmi10LQrTtxzuZV6fJhvJnLYx86y82UxyhO9szDZSrEUCHxVe6Fjv0fdEdFRZ2V77/TfxhzKCsLVsCVbU4X5Q2ZhGFCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715048252; c=relaxed/simple;
	bh=UUOmFdnRVJMaKlg6BOtDUP/jT90R3y3FTFKZx3K8Hu4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AxEtYg+WlCVFG8rrhfmQGxx4eHMyVtMFhZC7La0MYq582wNZi5UiRj2f5qZlY86Xgs9ROAcqYrVjGEWibsfBS3VxhH+c9Rq87Gt47xkqlEN73Aj9Efga8ZUKJC+kCGOPULs/ujQRDV8napupGgCAtpRe2uHF49miw6EIO3GRK98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1DxZjec; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-5c229dabbb6so1601198a12.0;
        Mon, 06 May 2024 19:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715048251; x=1715653051; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WNlF+4aE7JvU4ewsWDtXETsCJ1djlC6/3VF67xnJzas=;
        b=Y1DxZjecD8BBd6ATvsVpEQeLn+Oy3Y7AOMLk93LlgdXOZ9no8D3VFRMlGeIx8loVUq
         KW4bt/cGWUYLNZoKmjGjTRhEx2z32g3VUvq9R5H22huMEp5On8O9IAHvdB1MfvZfQ3n5
         9CapgR5k+0/MlBhzM/Xgut6UQJh+hlHe5mDNShuArlEhPgVrUDL2DIdLqF/txoFfA40M
         dMMVprNWMWwTqTxQDZ7gKv88HjoKBfB62QiHlRQeXdwpIzKqd1BHsjbtyMeSjW/mQMlV
         NK4FMBqj8IY4xx8E3YCqlALov6+LC578Gt8kG0V6a6IU2HDb0I7k/ivgD6ZrZDATegKG
         UT0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715048251; x=1715653051;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WNlF+4aE7JvU4ewsWDtXETsCJ1djlC6/3VF67xnJzas=;
        b=IOVNz84ytRq8KcHvIQJviMtLFCDFOtPrB6gWpvcx0h3oZIMylIEgerunkGejoP3Prn
         eBPtcf8yRvSl98R6t5YQfYw29QB0m4ycfKGln2JtgBpcsxU9V9n5szai6xYttL4Iac17
         BW0mb0cgchUi15YLT8eOzr9Oik3dPdL0rZOHZgnp3Dn1OGpw3fJyIdH3LfOncP3xCUCR
         TSlJW04qQDHw5DKrvByxGhRvL8A00tqfRA4gevTAAfd0/9RyM3cPBlyqJPLOzYV5KQmM
         WfcpmLu6ur/zNwoiEqeEFclAHHhy6VHFVSEwFwkayIQyxJJvZazCv58/eS4j+VZrlhLP
         rztA==
X-Forwarded-Encrypted: i=1; AJvYcCVqi7fGtwuctTfrXEyV6EDNFkeJXI1seHaBurKeKW4GfyUBWsz3K9/735b3PIk6u2VmvKjDz8GBHrH0nbtrdqaWoc6dgjETS/VaQ57I
X-Gm-Message-State: AOJu0YwgF3Ug8pNZeQ/n0UZ1vIgm0IAKPlbjq35OXUMfCu6GmxxgRxnB
	cuw6S5xRKuwPgYak+TOLjpvg679avtfS6rMEF2J8Gukh2xK8KxcF
X-Google-Smtp-Source: AGHT+IEe7ny/BXwbEtG5Z7CED0RZMOtuQJlWRrKt0JLFBHl3jnbuD4I/6/u5x4tnv0Ej71BRxlciYw==
X-Received: by 2002:a05:6a21:168c:b0:1af:b89b:a7f5 with SMTP id np12-20020a056a21168c00b001afb89ba7f5mr3244914pzb.24.1715048250554;
        Mon, 06 May 2024 19:17:30 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id u4-20020a056a00124400b006f3ea8a57edsm8357311pfi.133.2024.05.06.19.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 May 2024 19:17:30 -0700 (PDT)
From: zhangwarden@gmail.com
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wardenjohn <zhangwarden@gmail.com>
Subject: [PATCH 0/1] *** Replace KLP_* to KLP_TRANSITION_* ***
Date: Tue,  7 May 2024 10:17:13 +0800
Message-Id: <20240507021714.29689-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wardenjohn <zhangwarden@gmail.com>

As the previous described, renaming variables is not a good idead
becase it will break userspace. This patch rename macros of KLP_*
to KLP_TRANSITION_* to fix the confusing description of the klp
transition state. With this marcos renamed, comments are not 
necessary at this point.

Wardenjohn (1):
  livepatch: Rename KLP_* to KLP_TRANSITION_*

 include/linux/livepatch.h     |  6 ++--
 init/init_task.c              |  2 +-
 kernel/livepatch/core.c       |  5 ++--
 kernel/livepatch/patch.c      |  4 +--
 kernel/livepatch/transition.c | 54 +++++++++++++++++------------------
 5 files changed, 36 insertions(+), 35 deletions(-)

-- 
2.37.3


