Return-Path: <live-patching+bounces-2271-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CEiWCho0zGlRRQYAu9opvQ
	(envelope-from <live-patching+bounces-2271-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 22:52:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BD0C7371458
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 22:52:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CDE32302579F
	for <lists+live-patching@lfdr.de>; Tue, 31 Mar 2026 20:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536323A544A;
	Tue, 31 Mar 2026 20:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wqit+y/2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+koyIDM"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075AE3806A9
	for <live-patching@vger.kernel.org>; Tue, 31 Mar 2026 20:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774990358; cv=none; b=PFWn7lExekSQjtoubvZoqfZr1xaa7AlWdcDH1x4oW5am5PWABDksYW6C630Q5Iivbu25ZRhtG6YhiymxgEeXUX7xIBX4ALqKHWCm3pzYQC9lhL47Fg1O8nqpHdv7pxExulGxH2Zj+yaT4zloz+Mrvu1nS+TuNPI+tfMgbYaqhzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774990358; c=relaxed/simple;
	bh=8+UnT8vSH5x3hLrKGpP2WV538rU6FUTW4TA7XgOjUqM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=VNG52jmlcnY0SmJ/kg5HsaNEds71ZFoMQWGHZdgqpjMXQC/f1Rt5rMVZn2g78EO1JOF72BTvv5wLanYlOeTYmCwzbPosBzKla/JfoQLJ1iZzX0LNp6r2KbaqcxTEOon8AcD9sIlxNa3zAgGHgN5ubSrUEVXvRMiVb5/2R6bjx8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Wqit+y/2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+koyIDM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774990356;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jf5SVc6Wh+MV+1Py3i/pwSgvdn+BQX+ZgkhsoC83PmE=;
	b=Wqit+y/2a0yMcpdMzL+AlwklAKcgShT3dpN83Pa8HogZ8uGcpkfyPvmZ2WSnW5+zFk2uih
	UaCNq4r4+vdhwuG2iF7P4hEbw3IpP9f0xmoGq1s7oa7aBZqT8voK0yzGtRL5Z1C7RCluvV
	nnRFTDZgu87RfIRKdcByPcbGG7lwhvY=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-yMpxqS1tOfu1WBq7qZ_qSQ-1; Tue, 31 Mar 2026 16:52:34 -0400
X-MC-Unique: yMpxqS1tOfu1WBq7qZ_qSQ-1
X-Mimecast-MFC-AGG-ID: yMpxqS1tOfu1WBq7qZ_qSQ_1774990354
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-56aa6d6bb5bso5544520e0c.1
        for <live-patching@vger.kernel.org>; Tue, 31 Mar 2026 13:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774990354; x=1775595154; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jf5SVc6Wh+MV+1Py3i/pwSgvdn+BQX+ZgkhsoC83PmE=;
        b=P+koyIDMTLYNgaDndjUWSvhYddn+iT3K9eIDAQY1Il5d8jkCcJYymsrSvjvM6QA/rF
         W9gozg2gIN3FH+vOEIzrh7aW3GWYR/8GSjmtdouLFvfewiZUKVtb6e0ITpqcH7pg5lmM
         /S9xRmwC1Ov3eeZTB/y6P66n1n9WLgQDbcbQTXO5tdLf6e0CvT/5jI3arbZIxcbl+urU
         v3Qguuh+GS5OFqvjFkKnAr4rm8kTUy4MCSc88d+0KElC9KEOxl80TYtZCUp5yVR9vSXE
         hpwAd52mfKmyxCamP3DDaBixGmGCKRvgO8KvBXCfI0MAVs1nCSwSdg7QweGccg8GN3EK
         u5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774990354; x=1775595154;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jf5SVc6Wh+MV+1Py3i/pwSgvdn+BQX+ZgkhsoC83PmE=;
        b=PmO3cojWf/mfl7IbIchpCItY83CSDya+E8dn5CPlmUg7oQoV2Rl4HTS9gPK38d9Rzn
         SV7ekwifxrtTIH0NyUTlLLtH1AAzbQJFz68eOX1B8rO7OyCVpT3aqbLNjxPVcA73yFcy
         DKMeWBi3EC8YxeF4Q/eQn8iAySELhhyW3opLGj/eS2SRF0dSjPb0t7P3SVGNEeq9jKTD
         4u75zCeoXfj3iOsO8eFzutPziQ36PS/Dwd3ZrvUy++i1X4j040sZMAMyq4K1Kac339Ly
         2Ewf5X0sljd2iY6tXVRbasCAYsthb/XLeULgJLqlLZpMtvbQ+NwJa6VS3Teo/P837GKf
         j6bA==
X-Forwarded-Encrypted: i=1; AJvYcCWeEUxrnIdnNj9sjwGdcMzvG7U52Uepg877bkute0XpM0M2fFWQIR9/7YxFYXHUBcB+XbaQuw4VnptmcVU2@vger.kernel.org
X-Gm-Message-State: AOJu0YwqSdWt9wEp8O5TPzCa5eMCUCQyQyAckesogqA+l7zCTKcqoyvt
	yhyX6LdC3DdEGftOdTmgIpHb0IGPZYDdqMknSZ/SdRlLYBf++xDYTKjodX4669XtEwfktFoDTgC
	FvA3AiU+s5RvgY8XXNJGJXsk8b6rvFBuPnW59lh6K+yN45QeMgnMlfR+n94VZsUYjoV0=
X-Gm-Gg: ATEYQzySX+ht3T33ScJ/idQqykEd601Wg4kiah9THIT2KznmKiylV8qk33iqXjd/7bk
	dKA6c/jPLHf7lEhUA53UmyAGh1g2YBHift2Yqhi5o5+RaQQj8gm+qQAZsr79jImz0hRkxnvt6pu
	kpF23U0sN/beH9jhjjZwA/DrxvLYaHBwD/FOsFGi5g7DxAW/Nrx12ZkqNAnnWw5JMPmqRa+p5SQ
	814g9er8f8omUsY8ihJte08gKQ0xvZ8/WvoJE6QyhQ6XSWByKmEeE6rbD9Iuhu+gc4qhQfQYBXw
	eWIEjYh7i+QDvHthbGoaB1/n8PgMjrjkSsiCFFmLmhjpN05SvvAI0M/WlbuavNEwrjDhDCHoW4k
	xbHJBvz9o/u9DEwA=
X-Received: by 2002:a05:6122:8c8d:b0:56b:8023:b89e with SMTP id 71dfb90a1353d-56d8a8a5bb0mr521743e0c.6.1774990353571;
        Tue, 31 Mar 2026 13:52:33 -0700 (PDT)
X-Received: by 2002:a05:6122:8c8d:b0:56b:8023:b89e with SMTP id 71dfb90a1353d-56d8a8a5bb0mr521734e0c.6.1774990352988;
        Tue, 31 Mar 2026 13:52:32 -0700 (PDT)
Received: from localhost ([143.54.48.116])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56d588bae4bsm13748228e0c.5.2026.03.31.13.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:52:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=a749765ff5ddb75338189f0b931545c94d3203d4c9aa1b60eb5b58e37bdb;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 31 Mar 2026 17:52:27 -0300
Message-Id: <DHH9KCN1GVWT.3SC8M0FTLBRPP@redhat.com>
Cc: "Pablo Hugen" <phugen@redhat.com>, <live-patching@vger.kernel.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <jpoimboe@kernel.org>, <jikos@kernel.org>, <pmladek@suse.com>,
 <shuah@kernel.org>
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
From: "Pablo Hugen" <phugen@redhat.com>
To: "Miroslav Benes" <mbenes@suse.cz>, "Joe Lawrence"
 <joe.lawrence@redhat.com>
References: <20260320201135.1203992-1-phugen@redhat.com>
 <177436214729.62466.7977538958560300344.b4-review@b4>
 <acKje1XMQMQQYBIL@redhat.com>
 <177442832293.70541.15179138173140080388.b4-reply@b4>
In-Reply-To: <177442832293.70541.15179138173140080388.b4-reply@b4>
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
	TAGGED_FROM(0.00)[bounces-2271-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[phugen@redhat.com,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+,1:+,2:~];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: BD0C7371458
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

--a749765ff5ddb75338189f0b931545c94d3203d4c9aa1b60eb5b58e37bdb
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

> We sort of test the same in test-callbacks.sh. Just using different
> means. I think I would not mind having this as well.

Ok. The original idea Joe suggested was to check the function output
of module targets directly. From what I can tell, test-callbacks.sh
covers the callbacks and test-ftrace.sh checks that ftrace
can still trace a function after it's been livepatched, neither
actually checks that a replacement function in a module target runs.
I can be wrong though, still getting familiar with the livepatch tests.

> I was *just* in the middle of replying to the patch when yours came in,
> so I'll just move over here.  I had noticed the same thing re:
> test-callbacks.sh despite originally suggested writing this test to
> Pablo (and forgot about the callbacks test module).  With that, I agree
> that it's a nice basic sanity check that's obvious about what it's
> testing.

Fair point. Altough biased I think it is nice to have this explict sanity c=
heck.

> A nit but is 'noinline' keyword needed here? proc_create_single() below
> takes a function pointer so hopefully test_klp_mod_target_show() stays
> even without it?

> No strong preference either way.  I won't fault a livepatch developer
> for being paranoid w/respect to the compiler :D

Yeah I think you're right, not strictly needed, just wanted to be sure.
After some experience rebasing kpatch integration tests I've been bitten
enough times to be paranoid about that :)

But since I will work on a follow-up for the other suggestions, I think
I'll drop it there.

Anyways, thanks for the reviews!
Pablo

--a749765ff5ddb75338189f0b931545c94d3203d4c9aa1b60eb5b58e37bdb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQQMP+tqh8XWgfhXItgg/MNYDx+9egUCacw0DwAKCRAg/MNYDx+9
et7mAQCQ3BS4Tzt+l9lrgsw5/AiE6uK+9S9cTY3uaYshOqa7YwD9EDdExC61qsp7
+e6A4kEz6WT7/BhN+jL0JDNSIg8zdQg=
=e5bP
-----END PGP SIGNATURE-----

--a749765ff5ddb75338189f0b931545c94d3203d4c9aa1b60eb5b58e37bdb--


