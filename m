Return-Path: <live-patching+bounces-696-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEA898960B
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 16:48:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A88AD1C216B1
	for <lists+live-patching@lfdr.de>; Sun, 29 Sep 2024 14:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4E1B82498;
	Sun, 29 Sep 2024 14:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3Ra1jto"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897AF8F6D;
	Sun, 29 Sep 2024 14:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727621277; cv=none; b=hILMXXjIjWKKTSN2wXZSLQRnImd1DCXnb1h9YhZJI2zQDfly6GyWySL8+g2sb2QhnPfVZJ363Op/qYAvl8HKkWB/Ns/WfWkKjexEfcaAzF6+InhM4D7FSEXcqTNLtEGog77FkWvWq3xQwkmEHaykbaOsKqsuD5I7BXHPG/iCQYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727621277; c=relaxed/simple;
	bh=emBQzu+em/GrT1svHTRKjzwRsdHAgqjHivx/yElbuJA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=AtiQWzw7Vtf2HGYbPtooJxugH6b8uygkjpAVY2N36AZfie4itJcZSzJRyAYS2+ztr4AXEKgukNN/2xwuzy7bi+ZJm39ldrlHGBFsmA38sPlqclPnG0ru0pFOVF7UFtpFc1A6MUxBEYHLI2LqFcET2VBvijpL951ashFG2tBPGmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3Ra1jto; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-20afdad26f5so45919715ad.1;
        Sun, 29 Sep 2024 07:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727621276; x=1728226076; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KWWYLrJPijl70fRO9YuLhC/3Er+ARN2oS3gToYBgKiI=;
        b=C3Ra1jto5CTWf4BWDKqPa0lTHbnjNV8I+HSBwJDOiuGpzQDBYhEDhXsuUcBlkVLL4f
         lCFA2bCzJdZEYlSXKFPyEuWJbHkRX1724uP0gYKb2tP/ecqnF9BA6eaO7y3rP6nG10KG
         /41nqxUYYfQ2oHbLKK+lWWHlJz4eWq4ktS1l7UGfipugX7e8EDO3DPk7rXARq96YQ/OJ
         7i7FSDOg5sBS4FWuv27ntqpIbhOWRui5SRB9G90nJYOVjkxWueFUe2/FufaTEvrzfCOO
         UNHxtxPKKoqYhVGy82cIq1K+CATQXJOc5/FwkkSa5mWbTj+C/SMRZbYAPg2O/g/IjgvI
         H64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727621276; x=1728226076;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWWYLrJPijl70fRO9YuLhC/3Er+ARN2oS3gToYBgKiI=;
        b=xSERgG9LVqK/LiLnQKNWKKR6i4GRBy7P1d5yaO/FcNWjD8xqg1dT/IVesFwyHxIpXF
         PaexEf8huUUgkm8vdTgopI7SvNwcHuoWWXhCrBqS0YGvq6CHeAFN6w4LF1XmVQfzMkUR
         BuVlInaAHPZvAqhInd2exfratp3CQ8QpQvf3l/XmD4tnaR/+So5rHHy1niCILWz/8zym
         fB6+BUrfG92vS4YzPZ/BpFPBFKIMWsKT8D5GUcHFHP1ozxSzzur3b4Xn+emsS9pHhTd1
         1K85x5BE6jsCDjWHt4mDAg5bAUS8JlJAVdvRjkWxUu+hret5MqeLMf5/ZR/nXgDdXsHk
         TruQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpCGMgxAlJ121PMCN6WwB5Z9xfuq8yJA5UQlkXhiJNns1M7Fi6onQkWUBivj7vglwlvWJi4alvoUe8syyKmg==@vger.kernel.org, AJvYcCWPicQ3xB6Akl6Hhs0Mml3rRxqx8r5hAVCCnmJKVj7ZpXTMwjtv3duHRrX4bVEBNsy/H3M2dsPCC+PWaiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrk0B8AYYErE6pBopqEFNDbrxb4iBrlMK3aG+ioknWOaY0u5ba
	bWWYNyZXyAYrxqgTJYvtZjasLgGv/hYIrafMK1hsX43tO1pItMzr
X-Google-Smtp-Source: AGHT+IEOiGPPC642prcyZIdp40d69b+QokI4b85Uq5aeL1V8aPKdStF5/iCcxVzjBxvb6ynCjW7Esg==
X-Received: by 2002:a17:902:ecc7:b0:20b:5fb1:ea52 with SMTP id d9443c01a7336-20b5fb1ee30mr74513145ad.21.1727621275776;
        Sun, 29 Sep 2024 07:47:55 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e4e632sm40524905ad.230.2024.09.29.07.47.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2024 07:47:55 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce 'stack_order' sysfs interface to
 klp_patch
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2409271555430.15317@pobox.suse.cz>
Date: Sun, 29 Sep 2024 22:47:41 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <374E918D-7441-4B33-8585-1F547803F515@gmail.com>
References: <20240925064047.95503-1-zhangwarden@gmail.com>
 <20240925064047.95503-2-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409271555430.15317@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Miroslav!
> On Sep 27, 2024, at 22:11, Miroslav Benes <mbenes@suse.cz> wrote:
> 
> 
> How do you prepare your patches?
> 
> "---" delimiter is missing here.

I seem to found out what cause this problem.

I seemed to use 'git format-patch' with '-p' option which
will make my patch have no diff state.

Sorry for this. A newer version was sent again.
Please review the V3 patch.

Thank you!
Wardenjohn.

