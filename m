Return-Path: <live-patching+bounces-436-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6861294758A
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 08:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EEE10280CA4
	for <lists+live-patching@lfdr.de>; Mon,  5 Aug 2024 06:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B10F214036F;
	Mon,  5 Aug 2024 06:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fS1YJK0F"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521D7C2FC;
	Mon,  5 Aug 2024 06:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722840423; cv=none; b=llH6GWvyjrZw83YNr3r9+JtmVU233kwXPRM/ajG8UMFmk3qwxl9Z9iJqM3+Seg6rnpZ3XrxzID8aSJwl3QkJuoDFfX4G6FaWPzltW1AuCMmpgHpMMYjFhZ2mLejU3pkTwMt0YfWaQG1E2o9YZvLhEz+vgGh4Ub0i2sNkl8GsKPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722840423; c=relaxed/simple;
	bh=0VAwW9zgPxU6Af5/XZzFaklcXJ8jUzDX3AT5aG4Zv4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pCAtFyC4valZPoXz4PVJrkLy5TwyvU43hYC/KJUhyxn4GCSpLSLOBQNmYbSJ1hR+wfDkIJ2Fcz2HVK3QsYQ4kAsUiC5/+72oaOrgcGvfeYnIs6noAj2JTyRUjhZk8lVbdmiFcBl1pOFupYcz4wJLZduV+0qRVslgMRqsWkAGgBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fS1YJK0F; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2cb63ceff6dso6714021a91.1;
        Sun, 04 Aug 2024 23:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722840421; x=1723445221; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DmzMLlD0yCh/L42RmD9MM8nv5Bb/e8kZWETbPk0sPcY=;
        b=fS1YJK0FXtPoIEbxTF09EtGUK1Wvcv0tK3jQC1zr9g9MaWlYU0hx83CSGQwpGK50fk
         HHUBazZyVIt6cRONzCAqA0aRZ2QOmlRYEVTHElYZAYx+jaWTRPHRgrWs+2inZ4a2J2TV
         6ZyfxRt7580wsTRJobOl1SUZqobUUdwLR4wGdvXUAJwXrkjD0/pAwfeUk9jvduIF9V7C
         msduv2J4Cinp9JnEWJxuSkZvsjc5zDsVawL/sFOR0MwSnHzG7BZOrtVsc9S5cDLrTQs5
         t9URmn5zcv4CTeP/GwotHbPjf0NDAccHpbbcZ9oRNWX0bR+NQLnHZqhCiAW/U7ekPNVN
         bymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722840421; x=1723445221;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DmzMLlD0yCh/L42RmD9MM8nv5Bb/e8kZWETbPk0sPcY=;
        b=MQ2mAEe7xPG6gE8oPi23R2By6Xx7apf9PQBleD23C/54Sva114B9VSyRZUu6NLqqg3
         /nRkrW3bGdzIjtyBoB05xc0Cb1Q3l1eNC8F4aHJbfMlw/YzoRNbV8Edz/mSsmG8geyLg
         Ph82HE7NxOImbvemr0yb3YsZXaaKpW2RB/PrAkdLFPLhQZpoyqA51gOeb7wy/ITf5KSG
         CUcjeRg+7hXV7+PwXoAGfmlfHEt6UwOrHMwokNaBV5i9iZnwTivvIYf5jtBUHLomtyM0
         PfKbeTDX6iElyBzfiwIZEd50PLBPhtT8MQj0tdUORXV38yPVbLP25tFoKYF745TlxMvY
         DTjQ==
X-Forwarded-Encrypted: i=1; AJvYcCURAThnJZFZF2nOf1/leLHtlBt7HqE88Y2Ip+zCoRIvXMi5me30KEJ5a5719LX7qkW8/eLqJiWhoRin5Q9hzh0WE2yM7vn6jge/mQl/
X-Gm-Message-State: AOJu0YwYJ2ygNV65HUQ0P7dpcpveK1fi2dRo6AufPLI6FIcp91VIKL48
	/czEVmNWVnD2+8VhIBjF3ycbDtm3fsjew3E+2CPrupwguGosvzA8
X-Google-Smtp-Source: AGHT+IGGN8PspFb0JrdOQULxcQezvU7CKSpiY7YRr4z6/z/Fc9XsYKhW6sUGXRFTyxc5gzo1BSu8sA==
X-Received: by 2002:a17:90a:a00e:b0:2c9:7cb6:38b0 with SMTP id 98e67ed59e1d1-2cff9444f6bmr9168658a91.19.1722840421549;
        Sun, 04 Aug 2024 23:47:01 -0700 (PDT)
Received: from localhost.localdomain ([205.204.117.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2cfdc4cf16bsm9538444a91.44.2024.08.04.23.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Aug 2024 23:47:01 -0700 (PDT)
From: "zhangyongde.zyd" <zhangwarden@gmail.com>
X-Google-Original-From: "zhangyongde.zyd" <zhangyongde.zyd@alibaba-inc.com>
To: jpoimboe@kernel.org,
	mbenes@suse.cz,
	jikos@kernel.org,
	pmladek@suse.com,
	joe.lawrence@redhat.com
Cc: live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/1] livepatch: Add using attribute to klp_func for using function
Date: Mon,  5 Aug 2024 14:46:55 +0800
Message-Id: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
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


