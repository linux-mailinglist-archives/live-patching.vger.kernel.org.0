Return-Path: <live-patching+bounces-327-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 163A78FF438
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 20:04:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1089F1C2424B
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2024 18:04:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEFBB19923F;
	Thu,  6 Jun 2024 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FP+oP4FE"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334EE1974E7
	for <live-patching@vger.kernel.org>; Thu,  6 Jun 2024 18:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717697060; cv=none; b=Nc0OR7Fhd58iErDplGAjcITSd/IyWzcOwMPRQtb9NIsiKQcCQCwbDXqiib4tYKAgxF3xay/Nply4EFisT6H13euzgDo7UgjdvcsETMSAR5gSfwwb4lB2YloV26JZ0cBrIAcdyFCfzkouMGiFoZlN30tQNYi3IcD1G8fv7tgPbbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717697060; c=relaxed/simple;
	bh=da+imw45i6WbUyYnjdn/vso5vMNu8F/aTdzRiRx0Jm8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LpVSH2QJk6ATRfQsgE++iMaAcLvMbV1NRSVY+vhTzPLPVQ62xwZmJ+y1cpQluLlfMYj194nt/usKdZNpH48WltIei1cT619JqbGmNo+3UMHa6RB/C5ouzqEFGRPRGzjqfU+MsdKEhHyTnbAdqm0TRC5NTakxY5sWoTnRw0t3BLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FP+oP4FE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717697058;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CO0g1e2iEYIKJ/eo72YLUJTNuT2OqKeA+f4WWAhCUA=;
	b=FP+oP4FEDgh2HaiiWpZlKv9XuMtjsKEejf3C+FrrL9e1V2x8Qn2j7Tmzy8Vo9NR7nKcwKQ
	39bbsofuPdJ5uoBmTB4QfUI5ha84g5ATk/1nrrXFlvEdZ59y2xJJJgdSlgfayg5N91NsVF
	Jck9rfOvqCIn0B0e0e/cMh5igltyoV0=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-nOjZuZL8O_Cl1t1cRzE9Lg-1; Thu, 06 Jun 2024 14:04:16 -0400
X-MC-Unique: nOjZuZL8O_Cl1t1cRzE9Lg-1
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-3d200a9de76so1183296b6e.3
        for <live-patching@vger.kernel.org>; Thu, 06 Jun 2024 11:04:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717697056; x=1718301856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6CO0g1e2iEYIKJ/eo72YLUJTNuT2OqKeA+f4WWAhCUA=;
        b=AlMehIxnEU8C+yEB8KgMOOgCljtnCV3xKIJ/GuZtCrCyTSaEDyquJfm3WZNCj6XH2z
         aQ4FNQxlJ+k7ma/74Rb9lowzy3H+A1s/Y4bLEcxOuYE3h42IhGzHJGCGlxMvs56cLWgh
         Sy6E46Q0JkHz+40kbg0NrSf+digb4w4CME13dYh5MS2EozICqdOEIybQnGnGH+Q30biS
         91eLw5TrYGjEh2T47c7uFoExYr10ZfDwzJI37oGfwKbTwUkW+mggeXf711bkuoZU6PRr
         m/235lJYtEBUMjSFUnjmGs2P2rtF87eOIut5PYtteTsl8owb/hgnbf80GTteBWwed8CL
         3mtg==
X-Gm-Message-State: AOJu0YznTfMT8d0mhPe0ZrynLnSiM1t7ZHUKauZBFBhPV0yfUBDkr/37
	nVP7ST7h4Up4gg1jlyOT+ptqf1/DSiy7ElEuQHca/wzWf4Md+rG3dXrvsCJPcfm1ZUqk74Tdltv
	IoLr+erI8/6SIoPN8R7S2/xqWuFWHvLaS2Lb7wUGbp3sf0szM8E11vpgTmTecnN8ZlJAD27M6qy
	sLO5rvZ6VGv0pBvblkBbZwsvq9ond7oxDALhAnJg==
X-Received: by 2002:a05:6808:f01:b0:3c9:c350:bd40 with SMTP id 5614622812f47-3d210c5c58dmr321900b6e.0.1717697055847;
        Thu, 06 Jun 2024 11:04:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEMNpxDILxVYdYF+MIzB3EnzNYH3beUywsvqC9vv7lHss0Xq69PNun6Ju9dhGLMdY0RV9kmGV1cAXkq3BMPIBY=
X-Received: by 2002:a05:6808:f01:b0:3c9:c350:bd40 with SMTP id
 5614622812f47-3d210c5c58dmr321852b6e.0.1717697055422; Thu, 06 Jun 2024
 11:04:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <alpine.LSU.2.21.2405311304250.8344@pobox.suse.cz> <20240606135348.4708-1-rysulliv@redhat.com>
In-Reply-To: <20240606135348.4708-1-rysulliv@redhat.com>
From: Joel Savitz <jsavitz@redhat.com>
Date: Thu, 6 Jun 2024 14:03:59 -0400
Message-ID: <CAL1p7m7oHwX_OqyUiXqKh=x24d9b9x9gqNA6YEec6s58adAE0A@mail.gmail.com>
Subject: Re: [PATCH] selftests/livepatch: define max test-syscall processes
To: Ryan Sullivan <rysulliv@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mpdesouza@suse.com, jpoimboe@kernel.org, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com, 
	shuah@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 9:54=E2=80=AFAM Ryan Sullivan <rysulliv@redhat.com> =
wrote:
>
> Define a maximum allowable number of pids that can be livepatched in
> test-syscall.sh as with extremely large machines the output from a
> large number of processes overflows the dev/kmsg "expect" buffer in
> the "check_result" function and causes a false error.
>
> Reported-by: CKI Project <cki-project@redhat.com>
> Signed-off-by: Ryan Sullivan <rysulliv@redhat.com>
> ---
>  tools/testing/selftests/livepatch/test-syscall.sh | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/livepatch/test-syscall.sh b/tools/te=
sting/selftests/livepatch/test-syscall.sh
> index b76a881d4013..289eb7d4c4b3 100755
> --- a/tools/testing/selftests/livepatch/test-syscall.sh
> +++ b/tools/testing/selftests/livepatch/test-syscall.sh
> @@ -15,7 +15,10 @@ setup_config
>
>  start_test "patch getpid syscall while being heavily hammered"
>
> -for i in $(seq 1 $(getconf _NPROCESSORS_ONLN)); do
> +NPROC=3D$(getconf _NPROCESSORS_ONLN)
> +MAXPROC=3D128
> +
> +for i in $(seq 1 $(($NPROC < $MAXPROC ? $NPROC : $MAXPROC))); do
>         ./test_klp-call_getpid &
>         pids[$i]=3D"$!"
>  done
> --
> 2.44.0
>
>
Acked-by: Joel Savitz <jsavitz@redhat.com>


