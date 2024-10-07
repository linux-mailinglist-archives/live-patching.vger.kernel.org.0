Return-Path: <live-patching+bounces-714-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3F65992E6C
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 16:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27E1F1C231B7
	for <lists+live-patching@lfdr.de>; Mon,  7 Oct 2024 14:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FFA51D86F0;
	Mon,  7 Oct 2024 14:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlkdQWZ3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405AB1D61A1;
	Mon,  7 Oct 2024 14:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728310161; cv=none; b=QuytrVttMc7NDUN3IdPDZ9BRv76LLY4AOfJKt0J1RlQCd9j3W9gBZXimlk6SCwmesrtMvAP2g45oW35j2UTGu8hVPBe0bx2XG/lpdk+Nzv62C3YvHPxlMlj/W9iCfNB4Q1+hBnUDwvqX09Cypl6L5KNYs/ux9Ku5+LRPkIas854=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728310161; c=relaxed/simple;
	bh=2ZGVDOOqYvBcKIdCnpVHnmIdqw3mS5zuj+7qGuBaQv8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nYvHCF27hAD0OjW2EdUJxEu++LzvkOHWrPVJhUMGIdoB7+0ZOCNEvBJrOVV5HYeC4Q3BMfz4wWGnRn7gmgkrLINjeIniitd6rqQ/F6JYa/c6y+kyPkb8wjLPJZ2IUxmK59ESzfYxRgANzGKvXw8lzNVyGPFUUkzqslrIHkCpQLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nlkdQWZ3; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-20b78ee6298so28468005ad.2;
        Mon, 07 Oct 2024 07:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728310159; x=1728914959; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Xdsw7ujJ7Ar3peK2UZ1WC1wnxdC9L+8oKxAzxWDFHGI=;
        b=nlkdQWZ3r3lk/rgsiDwWRmYvv2/1x5uLG3/3kTj7Ddz93UzLHWRvMw46DAr+oWt3ic
         fZdVQlQyIWWn1220FDMM/CxJA9jMwyu0TrUJcGXmItPtHnBcF1GKxzYE7yVYb/ZC3ZOV
         29k4PItLNkHxOi346e7rw4UMsYoYZTBqHNMYVvLLHDdmFArfyTAHZ4296ab7sXgl5adT
         kEtY9lLwbmZiYE08S8Dqm5GZqRqs9SYf1JMtRCJsHD/G/IlrmgC7aIqcttK3YRlIhzlU
         9XIbh6/eINBmNgxdeLgJzcdLcqjJPEgF4o3lNSuSDYRRI/T3/jfmmY3X5sL4LAlBVdn7
         UrQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728310159; x=1728914959;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xdsw7ujJ7Ar3peK2UZ1WC1wnxdC9L+8oKxAzxWDFHGI=;
        b=TmCmqdmVp04xF8wgvzYuD5rjBCxymGKGlozqpPPOGpKfdJkUNNaV99Sv5NrXFJnd4Y
         mnBq/ZTudCU+ATnGlvW6z5sXsCg5yg27CRmMjVoe4to9GnfaCZE0f1HKtUGBZaGHbKYV
         8slWHKCqXWHDuYPxR68VYTxZb8ITXEUSHwRH6Q1AQH1YqAvRvHEuumSwvE6UpIASCgBP
         WmgljX3Dtsplm6xpVu5lzt9mvbMB2266tKzuZ0/YXma+Y+wbsuCPBeh6XBAV82KaAf0j
         VHea6gTnbrKcluRQJ+NuOhVSiKu9eCNS8zoF4re3F/WmaJ/38xrMidTEp/74R3j5bDux
         3Oag==
X-Forwarded-Encrypted: i=1; AJvYcCXhboRNtTOh6qD7zfRn0nEFIb1JH5B/REHMER5nSJtT5LMJTJsEo2KOrauEwNqI/daUpZzTrhmmZV+nWJg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBTicyVnOrKD9sCVHoAJyXMi3xY2iV6Vaf/LlZBxbjLmHtSkDv
	rQAYsj1MzUvQNfr/PlaiG+KiiPzXxmSpOhW2Xn4bsHRKKWyU09Yq
X-Google-Smtp-Source: AGHT+IFYzXSemnIJ53zMbdiYopE4SNDlqoJ74NUL+hK0mRbnsVX7vo+caXL6QGgGxVQXYA+5dySjrA==
X-Received: by 2002:a17:902:e541:b0:206:a87c:2864 with SMTP id d9443c01a7336-20bfe496d2emr179830865ad.42.1728310159243;
        Mon, 07 Oct 2024 07:09:19 -0700 (PDT)
Received: from B-M149MD6R-0150.lan ([2409:8a55:2e52:c0f1:4d08:3cf4:6043:d1e7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c13931185sm40303595ad.178.2024.10.07.07.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 07:09:18 -0700 (PDT)
From: Wardenjohn <zhangwarden@gmail.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V4 0/1] livepatch: Add "stack_order" sysfs attribute
Date: Mon,  7 Oct 2024 22:09:10 +0800
Message-Id: <20241007140911.49053-1-zhangwarden@gmail.com>
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

Regards.
Wardenjohn.

