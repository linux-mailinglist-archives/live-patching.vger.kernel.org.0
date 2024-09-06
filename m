Return-Path: <live-patching+bounces-617-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7564896EFC8
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 11:42:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA6741F24467
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2024 09:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279FC1C9DC3;
	Fri,  6 Sep 2024 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOARATz1"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C1D1C8FC6;
	Fri,  6 Sep 2024 09:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725615605; cv=none; b=aR4g9eHFk4MC+eUWATom3GxkvA5T+dUXyHG97EB6LEwoyqQqpoyLnD/qgICn2ODqKT5sO2RsjWi2E0iYXFZI844EOWo+tBfDcaTiFG4K2zFq3WUa0//zYtt1p4exGj0umVUkrZA+4SmMZvBbMohy5wQ0ibfwhO9uNiodI14xTQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725615605; c=relaxed/simple;
	bh=wIcE14jo8dACF0COzr4QaR10Z8l6bjtffgS+xdnCXiA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=AM9Q/tBs5IhiWEMMZTJRCCFNFy4ZucsqswxGalPSeg2zn8VBrN+x1LnWe8uH9zfD2KxmaipTB7hVQkVwfXrSBAJbjZaxhnrAHyyuV3y1gz2UgjZ6eS3DxAuRXBQL45NaqeaIeR4zAVgE0YJp4129B/O6+sdMsrvd/bMyagrcN9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AOARATz1; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5dc93fa5639so1128100eaf.1;
        Fri, 06 Sep 2024 02:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725615602; x=1726220402; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ni+lqLmpFmI+3F3vmCsrL2rz3UxTvkFZgSKMqY38+g8=;
        b=AOARATz1EKRSROOnXR7JKfeD8GWid0kng0k+J8ehXWQUFxOdWIm7ZsohhP/hypqHt4
         bdm64cK5Wb2FhnSBjHOOmqAW5GLcgrEKzrmVunUKdCJPM2aV/tV1SjB4XdIVZUiklwKM
         vqKUzq/UVtpZXzjzBapGu0eJ5xPR0yQzu7JOVfHkVEVBeayxWdjNkzsUPMe3OXbBSbts
         sGkFEi0IEg/eoTEIWGKY9CLE9NSfCjucrocASjz/Gg9bCirrv3B1HKe6n/lj1VIB2Lkx
         2kkVwyC7Lh8ExMdQXq37KvaCPI/VyKgyCwSTTW5x7Jrnkk8IQUrLk9NyX6oXGOgXUbqv
         sN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725615602; x=1726220402;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ni+lqLmpFmI+3F3vmCsrL2rz3UxTvkFZgSKMqY38+g8=;
        b=PO3dXAwf7/qBwIPJjbtwgmnfUQVazWzxVZhzxtt8ZUJkEUbNKdy9i20cKgUQTLxylu
         9p2smZjj2sEKApOsD+VBcbSNeNJHkcwS7s7I7x41Jy80dz3qq3KxT8UyNRqC9Mio0+4r
         hFQ83hUlm7iPw61PKud7Fu+I483cwKUQmG88AWxdMjxDnY86QFJAItb/vyRDolhjRHW9
         3BS3emodtg1q+iZwN1QNfMaIHHKS7HdDOCkEcHxwXzZR094Q6bMXabnWQCRYoIw8IBFu
         bfBajwXr5hUnNLvSS5ruskHdXKMlfJEgh9cuDb09aiVHTt4sobvlj7Ojn02RW5MEor7Y
         HvAA==
X-Forwarded-Encrypted: i=1; AJvYcCU10VFD1YU1eU5dv/BLfmHqVISsjR9HGuVWB6QkYyPPFLYd53aG0iDRfjl8e+8A7unvb3ANMyMjldyMxnffAQ==@vger.kernel.org, AJvYcCXsiOR4EdmAcDMQlB7ae18Rot9lKqzHf+h4nlBI+ji+PT8HbeRlr2EhOKbN6t5mgsN/Fh3rkW39IJuk7lM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL/7Rsmhi8OGQlhmYdPDVwSIpq+gKajZr6QTdloEwXpWtf+edG
	mH2TyRdsIbcdmbq/Vb6oDYRQbTFhE9/hviAGy4oG+sGaOPXh/4wHvFmy6g==
X-Google-Smtp-Source: AGHT+IEhibwHBYSfk1yMhLypaklqHdiqNb8Mbso3kRiwZLT3yHzW7ae+EEIoZ2say6EOwJ/AABpDXA==
X-Received: by 2002:a05:6358:52ca:b0:1ad:282:ab1f with SMTP id e5c5f4694b2df-1b8385e645emr259013755d.7.1725615601616;
        Fri, 06 Sep 2024 02:40:01 -0700 (PDT)
Received: from smtpclient.apple ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-718b39d6f71sm1132636b3a.99.2024.09.06.02.39.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2024 02:40:01 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240905163449.ly6gbpizooqwwvt6@treble>
Date: Fri, 6 Sep 2024 17:39:46 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 pmladek@suse.com,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <285979BA-2A85-495F-8888-47EAFC061BE9@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2409051215140.8559@pobox.suse.cz>
 <20240905163449.ly6gbpizooqwwvt6@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)

Hi, John & Miroslav

>>=20
>> Would it be possible to just use klp_transition_patch and implement =
the=20
>> logic just in using_show()?
>=20
> Yes, containing the logic to the sysfs file sounds a lot better.

Maybe I can try to use the state of klp_transition_patch to update the =
function's state instead of changing code in klp_complete_transition?

>=20
>> I have not thought through it completely but=20
>> klp_transition_patch is also an indicator that there is a transition =
going=20
>> on. It is set to NULL only after all func->transition are false. So =
if you=20
>> check that, you can assign -1 in using_show() immediately and then =
just=20
>> look at the top of func_stack.
>=20
> sysfs already has per-patch 'transition' and 'enabled' files so I =
don't
> like duplicating that information.
>=20
> The only thing missing is the patch stack order.  How about a simple
> per-patch file which indicates that?
>=20
>  /sys/kernel/livepatch/<patchA>/order =3D> 1
>  /sys/kernel/livepatch/<patchB>/order =3D> 2
>=20
> The implementation should be trivial with the use of
> klp_for_each_patch() to count the patches.
>=20
I think this is the second solution. It seems that adding an interface =
to patch level is an acceptable way. And if patch order is provided in =
/sys/kernel/livepatch/<patchA>/order, we should make a user space tool =
to calculate the function that is activate in the system. =46rom my =
point to the original problem, it is more look like a workaround.

> journalctl -b ?
> Store the state in a file in /var/run?

Getting patch order from journal is the way I think not reliable. In =
fact, I don't recommend to get patch order in that way. ^_^

Thanks!
Wardenjohn


