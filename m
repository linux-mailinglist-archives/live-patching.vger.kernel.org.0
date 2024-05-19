Return-Path: <live-patching+bounces-274-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48ACB8C95C5
	for <lists+live-patching@lfdr.de>; Sun, 19 May 2024 20:05:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 855E51C20DED
	for <lists+live-patching@lfdr.de>; Sun, 19 May 2024 18:05:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F82B50241;
	Sun, 19 May 2024 18:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="T+ciulGu"
X-Original-To: live-patching@vger.kernel.org
Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AF22233B;
	Sun, 19 May 2024 18:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716141941; cv=none; b=Xn3K3talARnpIp0dRrLF/V9NnpoKhCE08Fr3uRIeERO4ttfOeVxGrlJBE+NZ9S/3XEGrLwodOTXsHufwM6bS0fMrwl48OVEP8U73D7yEOxH3XkOs95U/bFUbD5Q4FC95LtbdI2IF7jNe5pPAU2z2b4JQeduCz2yfaizvxAEf0jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716141941; c=relaxed/simple;
	bh=27zJDYQNrBc3/Hgn0QfIK4lLVEOUFVMA6YO0B6tgoeM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=ugHJvwf0dLbL8ZAaq0/Ykt0mCSSeBp0WxrxCCF8ak8ZqlMoGBZ+BAxHL3qzEDUhLofsbvtZ9+d+1SD1glxDowg+9G+LgFwu7nhcGmOPtVwm7yUN8qVIfUs4kTpvNtRGE4UO0gIU7YtvxKzo+zLJ78jpMlaIZm4F01Yk98DHwptI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=T+ciulGu; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1716141928; x=1716746728; i=markus.elfring@web.de;
	bh=9pY7nZaq1fyJ1tTGdLEQrtwNkEiGqx7yo3oChVDxHLw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=T+ciulGuxb/TPkzLfXIxCqZ2o0nI6XR16AJkrXKJGT8XYJNCwyo3828sPsxG0ls3
	 a1/W3Pt7uNMsZ5I/55eumefhoyeIqwsto4CbEA9JBn2bmrxineehLs2rqIeYJBw0q
	 mjzm6gMS8B2kWqm2DgFIyJgoib0oJZb6dS2sbiieVbhUCRViRBBMfpWHpc4PpxAPG
	 F2KVCmMZFYirz4nf8I3igUfloRyO/SypSMl3TSo/G3A/datAEhKVOQwX1XKk+45L6
	 ztGNCQ/WU7Fp1kgbeREI4k4CitwrKeGXnjnWwiAmt1A+L22aenjKDMMtRVJy0icjO
	 0INfHWHAFShSQbrz7A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N6JxT-1sbm2z2hM9-016izA; Sun, 19
 May 2024 20:05:28 +0200
Message-ID: <0f78a187-5c64-4d95-a6e8-2b5c42f0c253@web.de>
Date: Sun, 19 May 2024 20:05:22 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Wardenjohn <zhangwarden@gmail.com>, live-patching@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>, Josh Poimboeuf
 <jpoimboe@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20240519074343.5833-1-zhangwarden@gmail.com>
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20240519074343.5833-1-zhangwarden@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:n1DLcPSd88hho6RTJCi/Ky4agc+v51xTm6fH0J9qsDGvMSA192g
 YH4M6HmPkcexPpMgU8+T3MvYMVK6WK+UGmlyFj5tSgSwgp+uctXpmsGRK9cbqbLm5fZP8t6
 Tc/mTk26VqY3KD7qBF0DiYfIFyZvaRKwL2k9vwOOQbzA24WuDco9C1wEyT9HX0M2hvE5EqQ
 QKxZej+3C7Vglx4kC8L4g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W9a7sCBMbpc=;fox0FO2AaYDVCTzkA2bWav5YlhG
 d7g8XG0CfKsejGDPLeB8/W7mPbph2E/XDTrW/R09X2X3Oo2AyhZ9fAhlywTgMDZbXs8AaWYDy
 gqdZEImiY9Cz58nipKQJGlfVSdWfRsXfnzo8G+CJd4BtpNtVLPHjm8neiasEF3RxZGvs1K/ae
 frEIfNhPJ2Wf2/KawV/JGg59iDpPldEtXENo2276YF8kRtHfixVl5K3l3AHWdW7fTVtgti7wT
 sHlL7TCNFnoIA7fWmz8xHyrRjKO4PdTx9jJxc49kvfADJLApwQkFIdqIX4ElqmNMq/oM/LmC7
 HKt/DBdU1ghg/5hQR0wviy6CdYoVLNx9PKkN5mPAPHwvZFy2VLSCvROlRu2/90/JhiFybRA1O
 Ap/zu6F/AJltQaj+Jmj5KRf41YdEe5HmFIIgdZ/j3ICzuKA/e1PWbf1xBkbBoodNcfn1543AL
 lmLUIh/zrsz5YZwFlQ1+tdfxVylQMMUfPJcL9YdhdzkSDy8UQ+Sl5srVNuqyeHCBSKnxyLr2p
 yhUjy7qA8frkhflT7uGeUZwHT90XRIP4N5GQauGm75kfdSKOz1PgCNHLWZqB9IllUUz/Rz2OB
 XwJrnfZoIusJK4v/kLQpwVb+Fl8oQaYEwDKXIsDMx9EZQriwynDtH0j7179N1JhwIXdFGR+fM
 T88+3GyGbEUNga1GmHbmHYO1MM1RmadEeJcz0b7zaLNmOKisdwUHNnekkL01hHFAPcxA1jUXV
 IvPNKsjyZaGtwZYMy9m7K6duj9qOFt1TbSRclD2sBPfJkl/tiWptCG23/jTMhMSs4fJzEHoeu
 0yw2JWUN3pNGSvNHWAXT9Z4QzO2YkTVEycRRupXTmIr8A=

=E2=80=A6
> This commit introduce a read only interface of livepatch

Please improve the changelog with an imperative wording.


=E2=80=A6
> find out which function is successfully called. Any testing process can =
make sure they
> have successfully cover all the patched function that changed with the h=
elp of this interface.

* I suggest to take preferred line lengths better into account
  also for such a change description.

* Please provide the tag =E2=80=9CSigned-off-by=E2=80=9D.
  https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/=
Documentation/process/submitting-patches.rst?h=3Dv6.9#n398

Regards,
Markus

