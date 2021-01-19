Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287AB2FBAF8
	for <lists+live-patching@lfdr.de>; Tue, 19 Jan 2021 16:22:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390020AbhASPUl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jan 2021 10:20:41 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46982 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbhASPUh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jan 2021 10:20:37 -0500
Received: from [192.168.254.32] (unknown [47.187.219.45])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3E20020B7192;
        Tue, 19 Jan 2021 07:19:56 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3E20020B7192
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1611069596;
        bh=4M3BwPAmE0MpFCFT5cBQUi4ZdOR5+mxe9RoI8L9IRuU=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=bRcE7bVhEVlU+tVlojYYNkZU05QeDNZOnu9hnEex930BBK/NMZpBOFaUZ2N+ly3HW
         l2qNzgjtiYvzwovV0mLV13rct9TcODH6CZbFcHpRNG/vHeFGedXngADhHxNAgfimlA
         k6yTUxZKAHyHJ5fBQ9qSx190h8mpfSOWA2Epigy4=
Subject: Re: Live patching on ARM64
To:     Julien Thierry <jthierry@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <f3fe6a60-9ac2-591d-1b83-9113c50dc492@linux.microsoft.com>
 <20210115123347.GB39776@C02TD0UTHF1T.local>
 <a5f22237-a18d-3905-0521-f0d0f9c253ea@linux.microsoft.com>
 <1cd6ab9a-74bc-258e-abf8-fcabba5e3484@redhat.com>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <32ec8721-90d6-c93d-f6f3-926c8876235b@linux.microsoft.com>
Date:   Tue, 19 Jan 2021 09:19:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1cd6ab9a-74bc-258e-abf8-fcabba5e3484@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> Sorry for the late reply. The last RFC for arm64 support in objtool is a bit old because it was preferable to split things into smaller series.
> 
> I touched it much lately, so I'm picking it back up and will try to get a git branch into shape on a recent mainline (a few things need fixing since the last time I rebased it).
> 
> I'll update you once I have something at least usable/presentable.
> 
> Cheers,
> 

Great. Thanks!

Madhavan
