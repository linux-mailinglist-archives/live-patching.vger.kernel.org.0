Return-Path: <live-patching+bounces-207-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 043BD894971
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 04:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD9F11F24658
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 02:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 308AF14012;
	Tue,  2 Apr 2024 02:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O76prp2/"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAE21758B;
	Tue,  2 Apr 2024 02:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712024910; cv=none; b=nwO1KXodFuTyxABFl59qbmuVS4C9VKLlC2eLQvrTdBBRSleP4qB+16QLVgVnROA/2ld330RYtXWC0993PefOl2Ezca52m1Kyd9iTPnSkri2uLUGPn/ifJKkBUsOFUFxgnqaYZKs16aVD64GBC+APeLOfR04tWDffSH6eJM/7Mhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712024910; c=relaxed/simple;
	bh=9GxZpS5Lj0HcYLYi2UFokjmolfgV0FtZe9eUz6WC3c8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ql4+8w3yIfHHpWdE2TaRCMp4cXwJzT+MTZm8xPeRMcIGt//V4IkuKuz+OsCCpVT6V3/ZOFwhtSGF8e3HX+1GRloKiqrCqWC6mSBBhWx0heHVItvg+LmnekXlgX/y4guKySdkgWlOkmSUiHkd/8muOPVu5AKTYhMFr6Bp1MhmdDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O76prp2/; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-69625f89aa2so37856766d6.3;
        Mon, 01 Apr 2024 19:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712024907; x=1712629707; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i+J01jlF3+HSprT0SLsFQqhqSGkIsEteHCUfiaSEJUI=;
        b=O76prp2/MVhKEIMlNDLLb2kGz0nhe3BD5ZAl2fWwIxI9NKuztqWYQ2nyKFaIFr+SjV
         z43/VmURqLn2lM7mWn6W35pDVHNpvfcggZ5paLpJOYLmElyuZ+G/htIzInJMNhgMkZxY
         I6yn3JyX2SXpYg3uOpUcyErRlri75YBIhkt5NDp7y9Bu7PWSa3K8vja7Ba6SzN/cFptW
         o0J3yrjTq1alv80/O2KrYDAo9ue7OaTtSrc5ubPUixUoVGJvvsz0pdR3UpvOSsp8afwB
         IXjnzwR1L7AofJ1P5rpgT10cU5rmRb7b7CswfPlHcBA8771ddGThnCCnir1nxpNJUo5b
         osEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712024907; x=1712629707;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i+J01jlF3+HSprT0SLsFQqhqSGkIsEteHCUfiaSEJUI=;
        b=M/OSRZyfY1TazsyCDAATg65yvn3U29o89zkbEiSIHc/lwXuRJV1vYZKjPv0rmSy7qZ
         I4ILok36GSNO9ysS/X51VnxGx07kxYVzi7jUl6DA9FumZheLtHmeIMLYOuopm2EGbkI0
         EOm+S0BrHZJeJd41npq+AHK9N/8XJORu90x56/mjLM/femK4aBtawr9z5DBa80G4jCIV
         AIZg9vRy1q6aqg4KNdjy0A28+E3tgsfPF2cuQcja2Et+WcOkMSz9fKwvNR2VJThSYuF6
         JNHwJ1ED9cMe1X47dIXpmhVZbmAJ31zz8iYGUzMFrdOvX3chJiYlztVvErW1UlnCKI9Q
         Mc0g==
X-Forwarded-Encrypted: i=1; AJvYcCVtrvrPyZ8ZR89q8o4ee9ww0qGhpkAZRd6Kdm+OP9IfgctXp8VkPozvdpIKMqcMeNwpYnsDJhBJksj//aI9wptUilKGXyxlShTA/ACrLfN0JQF1ObKkcWl3pRDeeeippDNwFK80ijLFS0GR2Bw=
X-Gm-Message-State: AOJu0YyXKUjSYwQGVh4JKtqRg/6576MTHGBKf90+jZ/Y8zxo6r94+T59
	b7IMOkaDGTVxW1htCPSdh4nXYDEQ00+9wG02gB3VInc/XzIIoFJXBo8DWKcnO1XHKSUjwx5V6wJ
	poFkZt5BzDBTP2fi2Hzs1vHJyx3M=
X-Google-Smtp-Source: AGHT+IGPU2qephPf76ym4szaBdDsgHyIws0c02qZ5sEsMiKhWohdhFbR2iZM9TZtBxWIzjm+Nj6MJ1fYjQhVdfV19bA=
X-Received: by 2002:a0c:f710:0:b0:699:1dfc:31e7 with SMTP id
 w16-20020a0cf710000000b006991dfc31e7mr2735qvn.59.1712024907560; Mon, 01 Apr
 2024 19:28:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240331133839.18316-1-laoar.shao@gmail.com> <E75FC9D0-22AD-4FB6-B9F1-CE4A7C9DBBA8@gmail.com>
In-Reply-To: <E75FC9D0-22AD-4FB6-B9F1-CE4A7C9DBBA8@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 2 Apr 2024 10:27:47 +0800
Message-ID: <CALOAHbCzfoz0r=PPUdSVsBeHEjdbB8jtZM3-foTMYk183EjjVA@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
To: zhang warden <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 10:03=E2=80=AFAM zhang warden <zhangwarden@gmail.com=
> wrote:
>
> It seems that you try to remove the disabled module by the kip replace. H=
owever, changing the code of sys call may introduce some unnecessary change=
s to non-livepatch module.

Could you please explain why klp_free_patch_finish() will impact the
non-livepatch module ?

> Is that really a safe way to do so?

Could you pls elaborate how you practice  the kpatch replace mode in your
production environment? Have you notice the commit df1e98f2c74
("kpatch: rmmod module of the same name before loading a module") in
the kpatch userspace tool that tries to workaround this issue ?
BTW, why do you think it is unsafe ?


--
Regards
Yafang

