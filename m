Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A4435E3C
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2019 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfFENsK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jun 2019 09:48:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726600AbfFENsK (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jun 2019 09:48:10 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 45A2D307D93F;
        Wed,  5 Jun 2019 13:48:05 +0000 (UTC)
Received: from [10.16.196.26] (wlan-196-26.bos.redhat.com [10.16.196.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B23C60C68;
        Wed,  5 Jun 2019 13:48:03 +0000 (UTC)
Subject: Re: livepatching selftests failure on current master branch
To:     live-patching@vger.kernel.org, lkp@01.org
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, tglx@linutronix.de
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
Date:   Wed, 5 Jun 2019 09:48:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 05 Jun 2019 13:48:10 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/17/19 10:17 AM, Miroslav Benes wrote:
> Hi,
> 
> I noticed that livepatching selftests fail on our master branch
> (https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/).
> 
> ...

[ adding lkp@01.org to this email ]

lkp folks, I was wondering if the kernel selftests were included as part 
of the test-bot and if so, do we need to do anything specific to include 
the livepatching selftests?

Thanks,

-- Joe
