Return-Path: <live-patching+bounces-2272-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKFaAuw4zGlFRgYAu9opvQ
	(envelope-from <live-patching+bounces-2272-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 23:13:16 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C68237175E
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 23:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C40FB305C716
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 21:10:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03C5D402B8E;
	Tue, 31 Mar 2026 21:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BF7FOLzz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="kpiCmpvU"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2B94014B4
	for <live-patching@vger.kernel.org>; Tue, 31 Mar 2026 21:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991427; cv=none; b=uz+yEOVY0RreO7Q08mjW5bvbrmgpHpOLsJzJmJzB/jFyLBXg5cl7cylMe9nKrLpzJuVx51oB22c7SHs/+Ux9tRgbKcL5iolDyiPApDms+PU1o641Bnm4l+mVLBXcaBFSLA5ImBUBoMCAVWMCfHRaj9lRl90RHTtsW8gn2A4SbQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991427; c=relaxed/simple;
	bh=V3QDfpUCHD3J70aYAoaXsLi0BbOWK1sx1MtxsffsVYI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=cCJR9KIWJUf/VYZM4z3k+byQhoO1mRbmyBybGgF/1ItCRi2En3TI8kS5Ha1MXZfQjUJbReKlDY0v8dh9BcKfeQBM6bRWeoTOg88AkI38CmArhxK5DroJbuwBpfFFEoUOgVRAa4wgSbM0lbipHyRHs3e+IhaJCV+J4nUFU5fxfLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BF7FOLzz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=kpiCmpvU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774991425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YlJ7p+iVljF4/jt/mLpXPYGwW4amrNrMTIm4YNtSvJc=;
	b=BF7FOLzzenqhGziolIPWlEfPd4nYlkotMsZ+IQEGD9mKY1FGWFgfz+H9x9GN1SXZsLTMNL
	hhHkhBL6aoSIA4It/YnOmG+GxMNDhd/SKkHqq8R1yolKz/+QzpPZgXsJmZ1c6Cop+Z6U9v
	gXlT8J+6A8WLbHn9NXxjpFifDk9DvQw=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-546-xfRFhWWtMQqS9O5_7VjPVQ-1; Tue, 31 Mar 2026 17:10:24 -0400
X-MC-Unique: xfRFhWWtMQqS9O5_7VjPVQ-1
X-Mimecast-MFC-AGG-ID: xfRFhWWtMQqS9O5_7VjPVQ_1774991423
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-56d39dd9a24so3784173e0c.2
        for <live-patching@vger.kernel.org>; Tue, 31 Mar 2026 14:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774991423; x=1775596223; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YlJ7p+iVljF4/jt/mLpXPYGwW4amrNrMTIm4YNtSvJc=;
        b=kpiCmpvU+r7iCYwdzRoBEDDuIPT6p8wOeAdLW0hokQyhO/zbLUDGrXCd4/B01VqsEt
         IybKBnriS8E9QLdUApn3iQQOB4dnwPcFe40S17tdpNh+jnIIXuCJPdy+XTmchEK26v5l
         ExI9gVK240sV5lEE73GZrvb+nBGD+4zTwXwvEieLDwlCWjhB2X6840+ggEe8btZRO7NT
         XW2KpqszwVqyUHk57CI6JuSE9AH6rwkmELJlYCXyg7BhWkNH5hwNX+TqK2DWHQxXwkTE
         LEy/CRNki3fF144loyWtdH0LpLdGiClDcKq8BXFj5FdcpoUx8kopnfjxcgTN4zpYsCTk
         oF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991423; x=1775596223;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YlJ7p+iVljF4/jt/mLpXPYGwW4amrNrMTIm4YNtSvJc=;
        b=VDggeIrGvV+CY/QvN43wdtHAQeF427gMSlLsbiNJN/HdPR39EqMtJvCPsvLfbZJice
         4LlbTC7MJoxheGWjxj5jBeznI5f3VTD5SZ9xcaUfq97j8/s55ov2tnMPb686dofezlN4
         cUxDA4NPvAppyfuZKVEjWYf+PuEjsoTngtHX0MkdKq6/o2Kkr5t3kVtQ5L8xN9rTKxZ2
         nWunVBpnUJoYN6lKldwQSjP33jgKSI+yFs19XP+r5BX/f6m5lpXf4S+PUmW150I8+81c
         Cy5Jt+vouxDGKKh2YZ7awrYOtBvg+8TMUeusU47une4a5Eoe1asHC2sD59JTyF+/fbrQ
         rFjg==
X-Forwarded-Encrypted: i=1; AJvYcCVmtgOXU0faYx/BA4mxMRVwqTW33thEiW9zw5zXa39sPYqSon388WEInfzLAQ5pNP6INE4tvyt9+TJ8De3w@vger.kernel.org
X-Gm-Message-State: AOJu0Yz38+dwEKFJXi/2ZRt1yyv4zAIkjHLo50tkd2gV97bjaGsr41KI
	iWZZ9J2VNU3aXpAFgexSm90Fia5SaTcRxFc8DBNamtyUPpTDFHteAnFZ5q1EEQ6C/7af7MYtyMv
	x2qC9/RrmWKzrzDx66Tl2f6v8vDAJE0pjmNof1AkvrUfxKEAITVJOsONbQN0xC/5k+Bo=
X-Gm-Gg: ATEYQzyqpJu09sqOWNxNz30Ukl8Nvgp+3Zk5Q+MRCyfrhDtYpQE1RGrroqjQN2+qnft
	/xZfRCfr7hmjnUO2GhqKSiJ7vVzMJz/duYfEVQpycJrDE9R5Znn2yMJJH5nyCZb2e0Nt7f5dBB0
	3vJQzUrTUJeKpK12Mi68shaUS7raio2H90cfU6J11Fi+EmlW5RnHxuuU/GSJEC9Y5Nq7/4fj4nl
	FmzfIzQtBjVX7dX4qxdVqnKKANZKPB4i7ytNHjBWVCJxFoiYMqLb2oBVdyNlLW97P6+O/uVg1iu
	lemzz0xwRazSTD3YbncmTx6q9PMoTh+BneXq4UzMy5KLyaLt3xT7f6wBR4n+FIzMkhA58N/gyiC
	P1GPAbBz4rVr4ieU=
X-Received: by 2002:a05:6122:469a:b0:56b:95a5:da18 with SMTP id 71dfb90a1353d-56d8a905828mr579908e0c.10.1774991422924;
        Tue, 31 Mar 2026 14:10:22 -0700 (PDT)
X-Received: by 2002:a05:6122:469a:b0:56b:95a5:da18 with SMTP id 71dfb90a1353d-56d8a905828mr579891e0c.10.1774991422440;
        Tue, 31 Mar 2026 14:10:22 -0700 (PDT)
Received: from localhost ([143.54.48.116])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56d58a333c9sm13810366e0c.13.2026.03.31.14.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 14:10:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=c254c86e525b2971ae8a9abacaab64ab5088645da2db68accb1dda6b2953;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 31 Mar 2026 18:10:16 -0300
Message-Id: <DHH9XZULMJOP.VB88ZIPXYI4J@redhat.com>
Cc: "Petr Mladek" <pmladek@suse.com>, "Pablo Hugen" <phugen@redhat.com>,
 <live-patching@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <jpoimboe@kernel.org>, <jikos@kernel.org>,
 <shuah@kernel.org>
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
From: "Pablo Hugen" <phugen@redhat.com>
To: "Miroslav Benes" <mbenes@suse.cz>, "Joe Lawrence"
 <joe.lawrence@redhat.com>
References: <20260320201135.1203992-1-phugen@redhat.com>
 <acVD_NPu4JVRoaVK@pathway.suse.cz> <acWZ3r2CoSDy_NLf@redhat.com>
 <alpine.LSU.2.21.2603271143310.31210@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2603271143310.31210@pobox.suse.cz>
X-Spamd-Result: default: False [-3.76 / 15.00];
	SIGNED_PGP(-2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MIME_GOOD(-0.20)[multipart/signed,text/plain];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	TAGGED_FROM(0.00)[bounces-2272-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[phugen@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9C68237175E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

--c254c86e525b2971ae8a9abacaab64ab5088645da2db68accb1dda6b2953
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

> > Summary:
> >
> > IMHO, this patch is perfectly fine as is if we accept that it will get
> > eventually obsoleted by my patchset (hopefully in a year or two).
> >
> > On the other hand, this patch would deserve some clean up,
> > (helper functions, don't die in the middle of the test) if
> > you planned to work on more tests. It would help to maintain
> > the tests.

> Right, I think this was a good intro patch for Pablo and that the
> revised execution flow would be a great follow on series, if he is
> interested.  How about that?

Sure, will take a stab at revising the cleanup flow. And thanks for the ide=
as.

> > This code is repeated several times. It might be worth creating a
> > helper function in tools/testing/selftests/livepatch/functions.sh.

Makes sense. Will include in the follow-up.

Thanks for the reviews everyone, and thanks Petr for picking it up.

Pablo

--c254c86e525b2971ae8a9abacaab64ab5088645da2db68accb1dda6b2953
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQMP+tqh8XWgfhXItgg/MNYDx+9egUCacw4PQAKCRAg/MNYDx+9
eqxiAQCGcnxyRstJp79GbB3BASfV3LTj9euCgFXlSYXqa41t+AEAmxNRxcKnhSIF
0sCDcIbb48AIFhU59jPUrvFU91tdXQY=
=6YsZ
-----END PGP SIGNATURE-----

--c254c86e525b2971ae8a9abacaab64ab5088645da2db68accb1dda6b2953--


