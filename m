Return-Path: <live-patching+bounces-719-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C905993C71
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 03:47:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98D3FB211E5
	for <lists+live-patching@lfdr.de>; Tue,  8 Oct 2024 01:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24E57C148;
	Tue,  8 Oct 2024 01:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="np99XyLZ"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E4E4A04;
	Tue,  8 Oct 2024 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728352041; cv=none; b=uGpi1UeZtlV3sppRfBLIZK/q9sVDZGYgaolnyHqGEBk1128Gtb5zRlLCIK4xqfte4AqSpVqoitb+Sz648AdrUeeH0nP8DEV/XsGTBkop76UQdrFcMwHK76i3eIcBlGHiErlD+iUTQxVfZ94A2vd7QISVmi8+6JB/IFdna7ztfa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728352041; c=relaxed/simple;
	bh=xe+mLhy1mC5gX0zdQpnYgxLJysglvL9+3dErRCv91Kk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OC1YvJTGeS++B/uzrvRJysJKEaU10D6FkiFFpUkXLS7LtWRngN3+fvJ/W9nIM/jNxM55QVsCVQf8tmvIDgmpCadnZfkpITdgf0PB2SFNKsn0JQVv35RUXY9URi/OxN80ssQhiXgL4Uir+6KY/5bbkRMKAR4LOtetKw98MnPNXIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=np99XyLZ; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7d4fa972cbeso3655119a12.2;
        Mon, 07 Oct 2024 18:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728352039; x=1728956839; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SFkkQdFHsjRATIB/ZQarPIg4vljCZMcv0ZUc8B+i9KI=;
        b=np99XyLZQmZS5oagUHr8azRetkKGy/Mp0T6MuJdLn4TcUtEkSFvrQ0zpexzkBnEKvN
         gyl886vm9Qk1Xn8FOb/yYA93r2HBpjsAEpe7aptZh/6y+mR24Ll2tgPnIOo4kTVfIxOn
         Ie8U0epmJzjezirqbW1wXzgYvBUmP80jPVTCcjvNFXyZFGll9JeNElgK4G28dXFqoCwH
         8/FdSs/EPH5vVqqwjdAAvlWg7z6NffoxXeJvV0hB0H0foWzz1gARVTcc9YZihHeo79M7
         x92hTFp0fFAjogXLuiy6PPkIKX374moxpzrxd8GISmjVmRcg5EZy5Arj/xmsTDDO8eAQ
         Zq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728352039; x=1728956839;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SFkkQdFHsjRATIB/ZQarPIg4vljCZMcv0ZUc8B+i9KI=;
        b=PlI1UHilYIGIe8nLwCXj+7H/4Fdc+x8rOe8M55Poa/DB1fPIRteEwSooYgmHec533M
         N//pSOTaqB13iEwHYJl3UG4WpghEzr0AMlONiFJw19kAfMxJ5WlnPHXCISzcUiSAayhc
         WFXWZCfCjJ3V3I5gIYuJdZU1pY8hM4njUqozz4VVjHRToPwziMbzAD7IUPMLxI+IyzDl
         GLWV71/+6ht2sapP3+8qLqLNtEEP/jouLU0/knJO4ngX8ft8qnBrSx94ZlbuijwANvLH
         gJ7GangdPdpoJwK44s96II+nAmB/26Hj9sDFovoD80ehOPhqVJw8QFJTpuOic32/X131
         eZow==
X-Forwarded-Encrypted: i=1; AJvYcCWrx9HDg5jjTcRpHNW3MGa4RZ/edUHwysCXzDedv7bbPR6+qS+iM9gj4MlHOhJvUsmCxJ8G50qQNz49ZJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCHQJcXULldRPq8AyW0RIKrmWx2dVzbcTJPByKicPz3NhFm7mj
	Vwx0yI+bHmxUTfosWTpqbkqF1B8bpdpT59r1QhU5neYNP/zfkVp1
X-Google-Smtp-Source: AGHT+IGNI1QXJeFVyjkOwpeYyhqhBG1u06y0+0VCOGwI1N39waGaN8Dk2l8URH8NYDL1Al1GXAeC3Q==
X-Received: by 2002:a05:6a21:a4c1:b0:1d3:294e:65fb with SMTP id adf61e73a8af0-1d6dfa422b1mr19531126637.25.1728352039099;
        Mon, 07 Oct 2024 18:47:19 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d453bbsm5070235b3a.130.2024.10.07.18.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 18:47:18 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V5 0/1] livepatch: Add "stack_order" sysfs attribute
Date: Tue,  8 Oct 2024 09:47:05 +0800
Message-Id: <20241008014706.3543-1-zhangwarden@gmail.com>
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

