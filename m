Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C29B1407A2
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 11:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbgAQKNG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 05:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726220AbgAQKNG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 05:13:06 -0500
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 499502087E;
        Fri, 17 Jan 2020 10:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579255985;
        bh=wABE1KL6Dom6ZK0s82ipPm+b7d+G3j2jQRbLEB2QhJw=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=NfdayOHo1oYl7k46HXKjfLoR0O9A88lnCmiyazES/WIG3kOFVbMOhBB7/k2B2tDnd
         Nb+ru+wNxgcZqLW8qBfOxDt59vzfzGPgOlmLFAODpJyT33wlCfbY0/b1N/F7Drvtlw
         +xu8KC2S8dkSxCtX40B1xVGdq/PjspMQthenCba0=
Date:   Fri, 17 Jan 2020 11:13:02 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] livepatch/samples/selftest: Clean up show variables
 handling
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
Message-ID: <nycvar.YFH.7.76.2001171112490.31058@cbobk.fhfr.pm>
References: <20200116153145.2392-1-pmladek@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 16 Jan 2020, Petr Mladek wrote:

> Dan Carpenter reported suspicious allocations of shadow variables
> in the sample module, see
> https://lkml.kernel.org/r/20200107132929.ficffmrm5ntpzcqa@kili.mountain
> 
> The code did not cause a real problem. But it was indeed misleading
> and semantically wrong. I got confused several times when cleaning it.
> So I decided to split the change into few steps. I hope that
> it will help reviewers and future readers.
> 
> The changes of the sample module are basically the same as in the RFC.
> In addition, there is a clean up of the module used by the selftest.
> 
> 
> Petr Mladek (4):
>   livepatch/sample: Use the right type for the leaking data pointer
>   livepatch/selftest: Clean up shadow variable names and type
>   livepatch/samples/selftest: Use klp_shadow_alloc() API correctly
>   livepatch: Handle allocation failure in the sample of shadow variable
>     API
> 
>  lib/livepatch/test_klp_shadow_vars.c      | 119 +++++++++++++++++-------------
>  samples/livepatch/livepatch-shadow-fix1.c |  39 ++++++----
>  samples/livepatch/livepatch-shadow-fix2.c |   4 +-
>  samples/livepatch/livepatch-shadow-mod.c  |   4 +-
>  4 files changed, 99 insertions(+), 67 deletions(-)

I've pushed this to for-5.6/selftests. Thanks,

-- 
Jiri Kosina
SUSE Labs

