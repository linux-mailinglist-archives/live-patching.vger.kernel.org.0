Return-Path: <live-patching+bounces-278-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AAA88C9924
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 09:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 053A628145A
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2024 07:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C012179BF;
	Mon, 20 May 2024 07:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REMDBuTV"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2289817991;
	Mon, 20 May 2024 07:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716189062; cv=none; b=lcZCJbOh8yliDkxjGFtfmz1aJDWugiwcZv+lDZmvPelX9GB80d1L3lBWqfBkYNCtG2nDSd0sqESgaLEIh9bJzY3YpoKkktAsTgJzU4G1f70EnDe9s2oUXZE9INKsNjl96eQOBeR/3CucVMfJnwe5K8RvsGni4PbMCcNSZhDsUsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716189062; c=relaxed/simple;
	bh=Xqp4WFSK/O1dCF/AoIOI2mi1EC2aT+nNHiw50mWgMi4=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ilHNZUGJa8m93vAfJhyI/F5grSe9r4eE1sU+2KC7mpcmVURpAaRkgNJQ2PIl8KR/Y/pDGMUkq+zmS3tTxmzLgtJl4Ik7agPQ8FdtONySxF3jsx36JJx5CVdcncsYkj1PUsD8+O9+pptTBdvo0WH+kuHKPm1LTuUkT9pYcgKxUX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REMDBuTV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ed835f3c3cso73065525ad.3;
        Mon, 20 May 2024 00:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716189060; x=1716793860; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GzRkDGtz7I3+/0/aWq4lp22/QhQlM4vFfLswyFGXHd8=;
        b=REMDBuTVsPIBIi5CsX10qqlieCvm06TFXkegLE6pNJcxVNgi+pw7UFV63HoavvFwOd
         8dLb0zKWuPdlIudbjLmk+2M/vufkH0Evw4Y9IV4+kWNeEK8xkaAfFCLhZoXnt3RHIaK0
         vOpTWOzE6xzdhxS3GoS71eCmuXG1/24776DGXcNZdFIsehAv6RWFPFzbjwrFsA4b6P6k
         yIwyK99mjfYOB7ja0K3+XaZ9wUOtEOr+KGbtOGF1PDmkOqPiHvTZjcpafzKFmemEYj2n
         upyU2OFVCx8DD2KriFLmGj3NNZ1opnUSwuzuAHj6yK07vxMjmBWzzWxnxSKQEhgSYPTC
         Pocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716189060; x=1716793860;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GzRkDGtz7I3+/0/aWq4lp22/QhQlM4vFfLswyFGXHd8=;
        b=hT13hU9vXZRXVm6ZtgWy+lk8Co2MAZlL7bJEzr+0sERuY4hAvolR9z6NRTk893tvYx
         TtoHQ8zu3pUQjltYYUfcFW35d7p8QXlHYvYHHxBChUpSUMbxCPR/f8EZa5CYBQdtLcjn
         ewQAJDOxz5SJHSP/mx80PtOX2VfOIQohlZsq4IB11H3NzMcv9Nmv3trJ6akn5nysugYA
         X1rVgt5dgON+YyrYHwMdZPzejgiK+ARNkpKPf7onpK0qMGYNFbV91OnYxB92WjOtXMt6
         YAVCJOoSXsyliMM9PA08cts+q56xa+HZfLVqZnpCPLTnG877u7GZbpA297xOmPEdVnTD
         szog==
X-Forwarded-Encrypted: i=1; AJvYcCUa5kgqA9W+xRUn6S3Y5qH0n8YmhZwNqxXHcDij7mnAVTkJ9zh9QvUoLqLHHJf9astOToszcXn0ZDQ/TAyNvqNAHizPPCN3kVaIvJsZTmFxG13dCVIpmOvC0cRSRrNXoIQNXXC593mrWs+Amg==
X-Gm-Message-State: AOJu0Yx1zyGX2MI6HeBbPXI+VKqbXMR5cBsoTlh7gxOiUV7pxYY9Ss11
	i4w1eOOCs3ad9OzkPUn2yzNKPk8VeqJAP6i99cmyLVPKc21NR5vY17eviU+G5qk=
X-Google-Smtp-Source: AGHT+IG4Ymvi2o+m4Cd7KR59fK5NFZa5IP8shdlOvXufN+TZu1xsj/UlyyJohS1f26TB2LTxebTbZw==
X-Received: by 2002:a17:902:eb86:b0:1eb:4a40:c486 with SMTP id d9443c01a7336-1ef43d17f42mr374476445ad.14.1716189060280;
        Mon, 20 May 2024 00:11:00 -0700 (PDT)
Received: from smtpclient.apple ([47.246.179.0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c03874csm195601135ad.206.2024.05.20.00.10.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2024 00:10:59 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
Date: Mon, 20 May 2024 15:10:40 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
To: Miroslav Benes <mbenes@suse.cz>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On May 20, 2024, at 14:46, Miroslav Benes <mbenes@suse.cz> wrote:
>=20
> Hi,
>=20
> On Mon, 20 May 2024, Wardenjohn wrote:
>=20
>> Livepatch module usually used to modify kernel functions.
>> If the patched function have bug, it may cause serious result
>> such as kernel crash.
>>=20
>> This is a kobject attribute of klp_func. Sysfs interface named
>> "called" is introduced to livepatch which will be set as true
>> if the patched function is called.
>>=20
>> /sys/kernel/livepatch/<patch>/<object>/<function,sympos>/called
>>=20
>> This value "called" is quite necessary for kernel stability
>> assurance for livepatching module of a running system.
>> Testing process is important before a livepatch module apply to
>> a production system. With this interface, testing process can
>> easily find out which function is successfully called.
>> Any testing process can make sure they have successfully cover
>> all the patched function that changed with the help of this =
interface.
>=20
> Even easier is to use the existing tracing infrastructure in the =
kernel=20
> (ftrace for example) to track the new function. You can obtain much =
more=20
> information with that than the new attribute provides.
>=20
> Regards,
> Miroslav
Hi Miroslav

First, in most cases, testing process is should be automated, which make =
using existing tracing infrastructure inconvenient. Second, livepatch is =
already use ftrace for functional replacement, I don=E2=80=99t think it =
is a good choice of using kernel tracing tool to trace a patched =
function.

At last, this attribute can be thought of as a state of a livepatch =
function. It is a state, like the "patched" "transition" state of a =
klp_patch.  Adding this state will not break the state consistency of =
livepatch.

Regards,
Wardenjohn


