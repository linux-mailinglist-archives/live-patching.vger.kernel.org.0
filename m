Return-Path: <live-patching+bounces-2249-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6FN/NcJOvWlr8gIAu9opvQ
	(envelope-from <live-patching+bounces-2249-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:42:26 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 960C52DB22B
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:42:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4A5A2300D1CC
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 13:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267FD39A061;
	Fri, 20 Mar 2026 13:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OWBGUbg8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9284A394795
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 13:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774014118; cv=none; b=VOPldCyfHdE/RjS8/JBtju1mse/7THN58p7drv2fa7g4F6+i3TbZde2xGuALIRWfALoIt5AtT2HIO9TfIMSIZcTUw2m50xXiyUdpAL4GBCCMjF5R06GhAYEog7l+V7INp98QAGOirqU+93IRepGqP9ws+WvOhBBugniW9oX6LSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774014118; c=relaxed/simple;
	bh=WwESOdXDfmYShiieGLB63KsCG1PufYfWbMl4RCcvGqs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tNz2EGsgTDsfiPNneWmHerxlmKqbV3LLGEjgzGrzqpdN/DXTe7q2yPHaEk7wRmIP07L+HqZiOHDreTPmwOVJ0In/gbUAolm8M49o/2QRpS8vTLuF4f/b0GInkpXE+2fGqQfXh5jtdG8G0HrbgYixw2T/KTVTxrSGu8b7cRwqp5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OWBGUbg8; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43b48ac2727so1539271f8f.3
        for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 06:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774014114; x=1774618914; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Pj4MC8T5uD6QbNxS5LtnCZJ45IF95A7XBuXQVLse3fo=;
        b=OWBGUbg8U7yySiSCsxCepQMPYLJwrEvvQZFPl/LXDyJqx2oSQv9MTYxlMigm15oA+v
         heebIcvE/1YiwYzyphFdX98IS2vruSIZtg3QUQGaAwkbKNbxaeWrz3fyS93lB+O8DM4j
         ymEaC3Dpm2J22gYfiZX/SL0ufH6qvnslQvzim5/CAgIbR0CX2OXOF1iqV0S8cz4mOITS
         W+f2MvDYYOA8KpoZ9NXaRD03/jg3cpOHE+updLYJKmfLT9gzWdM7E28jbR+LLqJokztt
         g9kwAawFDAU6Xn4owOSpDGTIREZH/zd+5wVh9yaWZp6WBDP7TEJgfg5l9DCvBBzrqqdx
         jiXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774014114; x=1774618914;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pj4MC8T5uD6QbNxS5LtnCZJ45IF95A7XBuXQVLse3fo=;
        b=jGnXd2I2XolDlW+e50qDvgEAmvaqbeprX0Ag3f1kJfifY2YIVoUA9eSQyiu57cP22W
         VXXGQjdK1PrEtbrDSN/U/vqjdvSSu1mmURK3M24xoN9+uqoGj9psab7fMHpiKdIe1j6+
         AzuKSNqjJ3LFwzj/hqW/1/dxGQhTTo4KAdm3G8mLPEcruTdQPOBOJONrSltWztah50hj
         UNz2Eio8oiIoD/cxwjY/iulfG4l1TbP2xnJBCNQf6XiCXgrlZHGCptGV+cIFu+OATWeA
         J3zNzRBcAOBjPsoWF5IRK18GkxqxdDJkLOgcCmE5giBG4U1SsWPHHuehCcmVXICdI/or
         f7tg==
X-Forwarded-Encrypted: i=1; AJvYcCUUsnil65IAy12JFykqvtRz9EgO43fXuVVDK5V8NSTX9PVO1BezvPoeiKockfrgVC/lOvqRxuR8XzE6onV1@vger.kernel.org
X-Gm-Message-State: AOJu0YygOo8ubxX9zLeocGUrSpB3P3ZdVwvRapel4hBm+uW59gTWSLy0
	IKWDWygGfsIJdUyC+LT4TLztcLcvdv6z+jev9wkVuVqIWc9afwkzNCVo5Q0e7SGBonI=
X-Gm-Gg: ATEYQzxBEcZ9dr1D9icYQRVAWnWa42KABm7Ss9g+niBxD+wcdQrGcYw1eiqiSUW1t5Q
	aNF5etBJ5vYGcH3ZYGWov4dxPhWTyxUKzLUpe7/oL5RqbSzr/TVleHSDniZr+awV5pprKWGGBug
	yMrRW0JcAskcHduWRi8cXZfMQcVlt3TpJvKO/4PGfvVzvaNsdt4nIsYH+ubSK+iTeIxeIYjS0vs
	eWDpAKqqWNVBIoJRzU9jn+WhS++TR8JP4KqzI4LBZZ3WO9hCjmapvSgXSgQV3wJQOS1azEV4Jli
	HyzdCvqTjO5ZMiQdq92IjYaXpwGIiNMI/fhHODVJ8mUP/hqVZeF5/rp9uxnQwrBlAlh7BOtXw+o
	Y/VslgfltA7guHzWEmq7skMJ+41KpfsQdIKjmYVzURWT3Du/WDpMFLnoQS8C7c6vkaI5XgSz6Zb
	bv2ex6LOrXMKASqHeOVkUVWm53f0mZ0fRbTZGKHw802CHKiA6IXgMF21q79ih7UiP2kUs=
X-Received: by 2002:a05:6000:1788:b0:439:d8e2:9a40 with SMTP id ffacd0b85a97d-43b644851a3mr5725374f8f.55.1774014113733;
        Fri, 20 Mar 2026 06:41:53 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b647177e8sm6628376f8f.34.2026.03.20.06.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 06:41:53 -0700 (PDT)
Message-ID: <ab5946563beb7551a65fa9b1a4ff78cd48ba4b24.camel@suse.com>
Subject: Re: [PATCH 8/8] selftests: livepatch: functions.sh: Extend check
 for taint flag kernel message
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
 Miroslav Benes
	 <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, Shuah Khan
	 <shuah@kernel.org>, live-patching@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 20 Mar 2026 10:41:47 -0300
In-Reply-To: <ab1K6oR06sLm9LM_@pathway.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
	 <20260313-lp-tests-old-fixes-v1-8-71ac6dfb3253@suse.com>
	 <ab1K6oR06sLm9LM_@pathway.suse.cz>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2249-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[9];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,suse.com:mid]
X-Rspamd-Queue-Id: 960C52DB22B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, 2026-03-20 at 14:26 +0100, Petr Mladek wrote:
> On Fri 2026-03-13 17:58:39, Marcos Paulo de Souza wrote:
> > On SLE kernels there is a warning when a livepatch is disabled:
> > =C2=A0 livepatch: attempt to disable live patch test_klp_livepatch,
> > setting
> > =C2=A0 NO_SUPPORT taint flag
> >=20
> > Extend lightly the detection of messages when a livepatch is
> > disabled
> > to cover this case as well.
> >=20
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> > ---
> > =C2=A0tools/testing/selftests/livepatch/functions.sh | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/tools/testing/selftests/livepatch/functions.sh
> > b/tools/testing/selftests/livepatch/functions.sh
> > index 781346d6e94e0..73a1d4e6acaeb 100644
> > --- a/tools/testing/selftests/livepatch/functions.sh
> > +++ b/tools/testing/selftests/livepatch/functions.sh
> > @@ -324,7 +324,7 @@ function check_result {
> > =C2=A0	# - filter out dmesg timestamp prefixes
> > =C2=A0	result=3D$(dmesg | awk -v last_dmesg=3D"$LAST_DMESG" 'p; $0 =3D=
=3D
> > last_dmesg { p=3D1 }' | \
> > =C2=A0		 grep -e 'livepatch:' -e 'test_klp' | \
> > -		 grep -v '\(tainting\|taints\) kernel' | \
> > +		 grep -v '\(tainting\|taints\|taint\)
> > \(kernel\|flag\)' | \
> > =C2=A0		 sed 's/^\[[ 0-9.]*\] //' | \
> > =C2=A0		 sed 's/^\[[ ]*[CT][0-9]*\] //')
>=20
> With the upstream maintainer hat on:
>=20
> I am afraid that we could not take this. It is needed only because
> of another out-of-tree patch. It does not describe the upstream
> behavior. It might even hide problems.
>=20
> We should maintain a SUSE-specific patch against the selftests
> as a counter-part for the patch adding the tainting.
>=20
> Or we could try to upstream the patch which adds the tainting.
> Well, we might want to limit the tainting only to livepatches
> with callbacks or shadow variables. IMHO, only these features
> are source of potential problems.

TBH I wasn't expecting this patch to be merged, but I send it anyway
since the change wasn't big. But I agree, we can drop this one from the
patchset.

>=20
> Best Rerards,
> Petr

