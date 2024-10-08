Return-Path: <live-patching+bounces-721-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24CAF993C75
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 03:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A49491F2236E
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 01:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1902914287;
	Tue,  8 Oct 2024 01:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cr7oUZey"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A0CBE4E;
	Tue,  8 Oct 2024 01:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352144; cv=none; b=FWYD1PIWDEPv5wMC2usEeWl/pcIoWlnKGWCTav+Th3nCZWQSb3I4w+Hi2Dk3/yNCcZwytmUjOy6N3/stOse2TCZJoPkfTlO4DGVdr5XS7BxFFp9hmotBXjOsEgTHAboX577Vh5rZBWjKFKatYa50HwFXZlYKgzZiy2AagYxLcYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352144; c=relaxed/simple;
	bh=xe+mLhy1mC5gX0zdQpnYgxLJysglvL9+3dErRCv91Kk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tgS5ptIc9GdiPCtYDfdnNFtiHyICyOkx0bXQJpVpWeWuQ+Lcr+sLJEVedM4ubWi/NfpUzEAT6BW1HRq0CnNPiLjKvFQDU4pqDyW90yguj8o/QoI5Rs+dmFiW8quvaVCjOWfIyBnLigde/SiQ6+A1ExActg9UJedK3RrsKRDqNv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cr7oUZey; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-20b49ee353cso47671085ad.2;
        Mon, 07 Oct 2024 18:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728352142; x=1728956942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SFkkQdFHsjRATIB/ZQarPIg4vljCZMcv0ZUc8B+i9KI=;
        b=Cr7oUZeyFPpfuLPtEmmFf6QI7Y9IjHlri5UeNO4aqZTPzitAmwtOhfuRZk6RNIxiZi
         Z+VXFoS7K6bi4ehgDkadmfhV4ml4t72P8gsV21gQhiCFbS8DnJS6wJ4T7sbr2C2fkk35
         4vxetIM2UuawGGWinnvZygXB5vEPiphOsWi35IldmOXH2lG999tEX0s3XAiLeF33sPWA
         pZFoP73iOHByetpOhlWo7zhU+c8leWPuSAa1OfCVOodRaB7bTR0XevUJgiROl85Ce9ZL
         pl2o+bXtasob2KFIlbpZ382QLnitC2qemi3v55yEMcL5XAkR2fNbvzeEXJXMX/78unKb
         a/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728352142; x=1728956942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFkkQdFHsjRATIB/ZQarPIg4vljCZMcv0ZUc8B+i9KI=;
        b=UrnQDmT/jhrzNZVoRifYOJXZLc8ksZS9t0yrWn15UGbdl9GMh2sFYYfRirvz1W9XzG
         qsFeortbLywnQ0M3ghKdjbgbl5x5Dno3KkXVG0w7WNPDBRsjCtpj/PWJiVU+Zc1+r2XC
         LoHpEO4CSWSivI6aaFLDBcqUT1Li0mB5BFTFIjdq1O/FMoQ+QAox89QaCljkjjsi/lkH
         noslSaIv3n3NzBmuTuw8OdNvkors9zMys31D8twrptAcu9IO0upxKq+evVptIB7OXdZJ
         bzk7WqWv1zcaC0UEPjc0pipUITKoJpi7YZK/xBdift0u3xks/qgXEWVL0ujGc8nKrT1S
         kuew==
X-Forwarded-Encrypted: i=1; AJvYcCUqeSHLXr5CW+xLfTvnsvS9/VVRB2/n4TzxA6IizdVl17T5tbNRTH+Fm7K7ZorHdrMjQITznCvJHXZNvUc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwH7SBAfT9+G5au22vwkZTxt6Jfz90oicAupP0BLiDHM5bL4SSk
	vvzVjNalXhqrott9I6gbgUBFFL0syK+DXajOsqaQ/XWKC8BokdO6
X-Google-Smtp-Source: AGHT+IFrukbERXA0cEifoaC0EdaFy4b/sb566PtOE1u7pxQKAHMndYwJBAWuq+rZtuK1mbVt79j5hQ==
X-Received: by 2002:a17:902:d50c:b0:20b:cbaf:c7cb with SMTP id d9443c01a7336-20bfde64e01mr228049665ad.6.1728352141775;
        Mon, 07 Oct 2024 18:49:01 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139891b9sm45755095ad.246.2024.10.07.18.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 18:49:01 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V5 0/1] livepatch: Add "stack_order" sysfs attribute
Date: Tue,  8 Oct 2024 09:48:55 +0800
Message-Id: <20241008014856.3729-1-zhangwarden@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As previous discussion, maintainers think that patch-level sysfs interface is the
only acceptable way to maintain the information of the order that klp_patch is 
applied to the system.

However, the previous patch introduce klp_ops into klp_func is a optimization 
methods of the patch introducing 'using' feature to klp_func.

But now, we don't support 'using' feature to klp_func and make 'klp_ops' patch
not necessary.

Therefore, this new version is only introduce the sysfs feature of klp_patch 
'stack_order'.

V1 -> V2:
1. According to the suggestion from Petr, to make the meaning more clear, rename
'order' to 'stack_order'.
2. According to the suggestion from Petr and Miroslav, this patch now move the 
calculating process to stack_order_show function. Adding klp_mutex lock protection.

V2 -> V3:
1. Squash 2 patches into 1. Update description of stack_order in ABI Document.
(Suggested by Miroslav)
2. Update subject and commit log. (Suggested by Miroslav)
3. Update code format for some line of the patch. (Suggested by Miroslav)

V3 -> V4:
1. Rebase the patch of to branch linux-master.
2. Update the description of ABI Document Description. (Suggested by Petr & Josh)

V4 -> V5:
1. Fix the typos from 'module' to 'modules' (found by Josh) 

Regards.
Wardenjohn.

