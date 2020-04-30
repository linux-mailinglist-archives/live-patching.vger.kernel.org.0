Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7267B1BF6FE
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2020 13:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgD3Lk7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Apr 2020 07:40:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD3Lk7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Apr 2020 07:40:59 -0400
Received: from linux-8ccs.fritz.box (p3EE2CE96.dip0.t-ipconnect.de [62.226.206.150])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DD62076D;
        Thu, 30 Apr 2020 11:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588246859;
        bh=dFK5BA/3XELie2QyZAN3A+reesHvuM/84wvUzjlEXjc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oJ4vqlhY9q6mW0qaJe33gktp4qfSReNIRP0NffZ1fV0NhvKpNzX2KdeK4p8uNboQB
         0Wbbf1HDJV8lRESWG9GcD2SqxXScTe53oQmYrQj9MDmVgWNRPa87HGh8yM+x6JEbXP
         69CfnTSEyai536ZC6PxTgj6+ywFAhvySsZV/B/ZM=
Date:   Thu, 30 Apr 2020 13:40:55 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v4 11/11] module: Make module_enable_ro() static again
Message-ID: <20200430114055.GA15426@linux-8ccs.fritz.box>
References: <cover.1588173720.git.jpoimboe@redhat.com>
 <d8b705c20aee017bf9a694c0462a353d6a9f9001.1588173720.git.jpoimboe@redhat.com>
 <20200430111032.GA4436@linux-8ccs>
 <alpine.LSU.2.21.2004301334560.8465@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004301334560.8465@pobox.suse.cz>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Miroslav Benes [30/04/20 13:35 +0200]:
>On Thu, 30 Apr 2020, Jessica Yu wrote:
>
>> +++ Josh Poimboeuf [29/04/20 10:24 -0500]:
>> >Now that module_enable_ro() has no more external users, make it static
>> >again.
>> >
>> >Suggested-by: Jessica Yu <jeyu@kernel.org>
>> >Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
>>
>> Thanks! Since this patch is separate from the rest and it's based on
>> modules-next, I can just take this last patch through the modules tree.
>
>It depends on 8/11 of the series.
>
>Acked-by: Miroslav Benes <mbenes@suse.cz>
>
>for the patch.

Ah yeah, you are right (you meant patch 9/11 right)? Will take both
through modules-next.

