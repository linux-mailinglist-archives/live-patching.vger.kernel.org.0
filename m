Return-Path: <live-patching+bounces-465-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 700A294B704
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 09:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9023F1C23B68
	for <lists+live-patching@lfdr.de>; Thu,  8 Aug 2024 07:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD69187845;
	Thu,  8 Aug 2024 07:00:28 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D0F185E73
	for <live-patching@vger.kernel.org>; Thu,  8 Aug 2024 07:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723100428; cv=none; b=UrsHfgnwqJsfGUHAaMXPDGQQg2QeCSHwy4tJMmQkgRL47xubGIWAg9kcFbhq2DH1bm7aW2Fxh1FB5PsmyT0nZIR/NB+NOQqpn5+i7/DNMenmM0E8HM7YAyiCRavQYbeG3xTTuOempGK8JZvuimOJh+PASubZ87UXZQ6I7c39XbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723100428; c=relaxed/simple;
	bh=5OlsLIs23Nw7JUsJjh4Fv1EMhb9ogWG3DeDeNx7OwvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TkQbJj1phu1BmNtF2gnQggAssTIJqDUMARVK0nRH1pzll//77FBgxMZ20mRXMNInpMz3BZGtuvewopnmK/ZBp0MUJASA75lnwFWPlqBhHRREL3ZmKVgkQVg4AapeY0FnSaCf6ZD0BoVbs4+IDEb0aSHh/rG4+1sEe62WF+zZNNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4WfdGZ54Sqz9sPd;
	Thu,  8 Aug 2024 09:00:22 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FF_P4QsPbfUQ; Thu,  8 Aug 2024 09:00:22 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4WfdGZ4BYXz9rvV;
	Thu,  8 Aug 2024 09:00:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 7FC298B76C;
	Thu,  8 Aug 2024 09:00:22 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id OS09V1Nd9zN9; Thu,  8 Aug 2024 09:00:22 +0200 (CEST)
Received: from [192.168.234.168] (unknown [192.168.234.168])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 0259A8B763;
	Thu,  8 Aug 2024 09:00:21 +0200 (CEST)
Message-ID: <79fffe34-ce0b-4937-a85a-0ce566684887@csgroup.eu>
Date: Thu, 8 Aug 2024 09:00:21 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on livepatch
 sibling call
To: Ryan Sullivan <rysulliv@redhat.com>, live-patching@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Cc: joe.lawrence@redhat.com, pmladek@suse.com, mbenes@suse.cz,
 jikos@kernel.org, jpoimboe@kernel.org, naveen.n.rao@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com
References: <20240724183321.9195-1-rysulliv@redhat.com>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <20240724183321.9195-1-rysulliv@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 24/07/2024 à 20:33, Ryan Sullivan a écrit :
> [Vous ne recevez pas souvent de courriers de rysulliv@redhat.com. Découvrez pourquoi ceci est important à https://aka.ms/LearnAboutSenderIdentification ]
> 
> Currently, on PowerPC machines, sibling calls in livepatched functions
> cause the stack to be corrupted and are thus not supported by tools
> such as kpatch. Below is an example stack frame showing one such
> currupted stacks:
> 
> RHEL-7.6: Linux 3.10.0 ppc64le
> 

...

> 
> This is caused by the toc stub generated on a sibling call:
> 

...

> 
> This patch restores r2 value to caller's stack, on a sibling call this
> will uncorrupt the caller's stack and otherwise will be redundant.

Be carefull. On powerpc/32, r2 contains the pointer to current struct. 
When I first read the subject of the patch I was puzzled.

You should say toc instead of r2, or make it explicit in the title that 
it is for powerpc/64

Christophe

