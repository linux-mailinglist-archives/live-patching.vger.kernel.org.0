Return-Path: <live-patching+bounces-2931-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CAaaIItXGWqCvggAu9opvQ
	(envelope-from <live-patching+bounces-2931-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 11:08:27 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 103D35FFB05
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 11:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A7DA3028AF1
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 09:08:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99D073BB13E;
	Fri, 29 May 2026 09:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwX0anmA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174FB3BC668
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 09:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780045702; cv=pass; b=p9G5q6CHnRSPJ1sKJCvuuWtkIMKFme20JH75POSyELbfQNSiOmZzibUZ7UgFpc3Cy66gvhEzTI73l0RwZSKijAg0O7nv7u6KdjZ5U0nhuS7FVnsvYXFc59+UUYKzcnaP86hlzW6Jp9FWiZcHPMM7qfFWGgNJXb2bOgR9BjRQR4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780045702; c=relaxed/simple;
	bh=Jtyy327MuOiiBAAUFhMnxBn/7M3zF2JyklBo8IFhomQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=exuPbPn3UDgN2sgLwMEYifG/QxwaVZFrHe1V1YsCCdrW2y4AhITUVUGHI9G8zLKTD3k6sJzADSo7pq0Hud+j3HZ9D2pyUrbWMsoOnBlhSuoCBMxafpkaDIBWh4pQSrbjXUsgNFHWU6lidgAk9421TPzspJ0T8GgLu/zMuEtsOpY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwX0anmA; arc=pass smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-7bde9d73678so143917017b3.0
        for <live-patching@vger.kernel.org>; Fri, 29 May 2026 02:08:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780045700; cv=none;
        d=google.com; s=arc-20240605;
        b=jKVjLOqADFxAjJYJOxt8seXGIBYCVgQb9+d/1CT2u3zUByDmCQRWla7+SAEXRi8qov
         dWfrzTWw/n+ve+Z93g1tZamIgCiyeDN0MHaqTp3QkrW/UUxIVpmYUJH6uZLsbPD8AYXP
         KipnPNtA+KDRlg+y78Yg6ehy/TjT7Z6Z8j6wZdSDWx1iHgub5CfgTb8EI6ssWb9zlGdk
         Q48ojo7XKpdSKiyPcX3l+aETnc2LkQKQzs4knUI59M4RZG780ZE3eFi+PQva3wtuDZJe
         5xfyItIgzge3jr5hLHg4T5dtVgy2h0ebahdOeKmG1iema5jm019WV1j3lby/Wcl65qxJ
         mrfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jtyy327MuOiiBAAUFhMnxBn/7M3zF2JyklBo8IFhomQ=;
        fh=5Rdie+I/J+CwGrXhNdcg9kxpduczK2/ze4SW1cztuvM=;
        b=QtZgu/xeNA0BtxOzAwCmYmGJeaQ7rUEG8V29zuEWTvf4gFEhddIw5h2XHPDwZUyODr
         Ix/oowuStyqIn+1nRwO8l0CDowSpN7lTDckbcYCcqTKsxxTYM5lUPFwc2WbWKQHoQ/8K
         fLe1Rh/pfjKJlQyU5OFrVdWc5hUo4jaL2vMcRFejRyk3Dea18AGsGmrj36RNQlsziBrT
         /azt+vj4y0COv8m6A4UCxwd9J0tAQVU4SknzcJbBaK5Fu5i/hUy8ntS0TBdZvYrqvr/e
         j0Yg3X3v6TB2z4K9g9zpEJdPIhSz+hNjrW9+juHCyLZHnaJBYcX355uFQ+vV/qykOUf5
         PjcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780045700; x=1780650500; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jtyy327MuOiiBAAUFhMnxBn/7M3zF2JyklBo8IFhomQ=;
        b=NwX0anmAGMH/Y/tZOpwQLRbPwMV1oSb+/WI7J+H5m872yrPyQ1Ed0HHsnw9DG56jo+
         YWWKYPB3om1yNYCe7UvihLW2bedvxOzY0qIJubxdQbLcWfBNbaQMRCWSmgcRKX8acar+
         woBQBiyOcIKBc2bjSVhQAiXxMfnx5lN7wwc3CzGUKKIaS/kg6UJ6tGjeebC0fiKWb+Lt
         A7WPW5mnWeuR/ja/tOghOzk6nE5Os44aqiYfS6fxPjmrXlFhJRhG23MvVQtnNQ7MODtI
         sWLvtgxdgjYz75OO3iMu6FdjF2mgNGn+WILdpR9smjQZLrWAy0fpQ/nIAgF+OTnBy8bT
         +Mxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780045700; x=1780650500;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jtyy327MuOiiBAAUFhMnxBn/7M3zF2JyklBo8IFhomQ=;
        b=U27Xa4aq3xCv44Yi14YvtkyDDVGPV/HHWiFEEBEIq7ch5z0av2QdRzi9sHQJ/KrLZ4
         ZYTmAAzing8p8KSDonNK1BpblNSjhTKzIi5rEBlM8NTIlMimqVWn6gHDr47iw0V07xtb
         7jkov+mjWESHKPkpBO0ReRkVGjMasXYCb8P0PWZlg/jZootOVCLqYP70iRTGkJ4jlgHj
         yVQeuGL9Xjt+TL3OuMEoxi330OSuHVXwyaiUS42WaovhVVF8H5j6Uhkfh5a1htHYgBn5
         6JDeQcgzFNhOkQxNt6zguOtCfLB6fJl2z7QPP87oz07/wO7ycmG0MVuRnEp+wYBPc/Kg
         G+hw==
X-Forwarded-Encrypted: i=1; AFNElJ9pq8KnN1egiToKUikPtL7B+gQMBuz7V1Qu4lbTtmYjXwQQu0gsqtqfSiUaj8zzknovpeO5sjurXhOhPym7@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv0bqaMZ2vYBWCxYuDK28UC5rKKRfy3Rs6kJ9xcaP5i8/V811B
	s1hiYsotNACGMirG66hEz6yrEZfJBoGEZ3g23eIMvG5s7AJa5/dpXPINLVvCHzCLluezAMge7uq
	W4ILF4JwEj0o/bFHwBpYPmAFQ/a6j/laVKrQb4UMMeA==
X-Gm-Gg: Acq92OEmwi/HS/oklK4VkPxJsJTS8w3jSrD8j8bTwJ+1ttZ2H5OO+LFTZsEA6DvQP+9
	ws3EPA9rcB9mU6XrJWZjJIHxKNcxdkU6974ULcF8EInt3vwL3VM0bRvtzd+jYjakCpznhjT3pth
	7zisnk7XAlvRcu0kbzYoCUH88nFBToaOJDly9sjZMZBMAmjj9fe2l79u/9Up4ZFragw78l7CAQT
	3WzcITnWXUdnG5AmCS06xFbE8ANWxCEG8zgwWaEh7ZH6zZ1RnXpK96LbFGkRZnj4NDxwlTzTQkM
	mUT1DevqcTlRfqSVoPPImGkeJxh7OdehVRRl5h4Y4W9cKlDyoj6tPVvqjTIV
X-Received: by 2002:a05:690c:74ca:b0:7bb:ced:fef9 with SMTP id
 00721157ae682-7de30fe4528mr14967637b3.13.1780045700040; Fri, 29 May 2026
 02:08:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260529034542.68766-2-laoar.shao@gmail.com> <20260529040130.95A9C1F00893@smtp.kernel.org>
In-Reply-To: <20260529040130.95A9C1F00893@smtp.kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 29 May 2026 17:07:43 +0800
X-Gm-Features: AVHnY4IO1MQr3CJ2f801kAPxEYuANbMO06IQrG_toAInYYDc0q5hFpleeSy2jgo
Message-ID: <CALOAHbABz7CCK4spQj4-ApKqJhPXOsWUiuX1fyrDWAyvEZFV2A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] livepatch: Make klp_find_func() non-static
To: sashiko-reviews@lists.linux.dev
Cc: jikos@kernel.org, joe.lawrence@redhat.com, song@kernel.org, mbenes@suse.cz, 
	jpoimboe@kernel.org, pmladek@suse.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2931-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[8];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 103D35FFB05
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, May 29, 2026 at 12:01=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Low] klp_find_func() is improperly exposed in the global public header=
, breaking encapsulation and introducing potential build/linkage errors.

I will update it.

>
> Pre-existing issues:
> - [High] klp_find_func() lacks input validation, exacerbating a pre-exist=
ing NULL pointer dereference vulnerability during livepatch loading.

Valid. will fix this issue.

--=20
Regards
Yafang

