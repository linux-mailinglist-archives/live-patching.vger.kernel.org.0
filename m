Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461AF348730
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 03:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCYCwU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Mar 2021 22:52:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:54646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230006AbhCYCvw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Mar 2021 22:51:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616640712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O40ZXFmREbbNLPasEc4QZD9qoO27te5cNeANN7AvMJs=;
        b=NHr0OvNThyrFlA6PJfG/+E7eqA17l5duT1i3Nl4SxGJfoPmxO/lLhuD1Kjh0BjuK5oBn+A
        qIHyng7k1S2c/Xn5yO0iXYqXFz6CIuNvmSX46knS4mpRsfOZH3sxy7Bye0MsjIqMajvunh
        /zZHepEXwRnGZtn/g/OQ3kkx19Rpi7E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-534-joTU2e24NFarjDDTNS2ftw-1; Wed, 24 Mar 2021 22:51:49 -0400
X-MC-Unique: joTU2e24NFarjDDTNS2ftw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8EC9988127C;
        Thu, 25 Mar 2021 02:51:48 +0000 (UTC)
Received: from [10.10.112.16] (ovpn-112-16.rdu2.redhat.com [10.10.112.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1731E5C257;
        Thu, 25 Mar 2021 02:51:47 +0000 (UTC)
Subject: Re: [PATCH] livepatch: klp_send_signal should treat PF_IO_WORKER like
 PF_KTHREAD
To:     Dong Kai <dongkai11@huawei.com>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com
Cc:     axboe@kernel.dk, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210325014836.40649-1-dongkai11@huawei.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <cd701421-f2c6-56f6-5798-106bc9de0084@redhat.com>
Date:   Wed, 24 Mar 2021 22:51:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210325014836.40649-1-dongkai11@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/24/21 9:48 PM, Dong Kai wrote:
> commit 15b2219facad ("kernel: freezer should treat PF_IO_WORKER like
> PF_KTHREAD for freezing") is to fix the freezeing issue of IO threads

nit: s/freezeing/freezing

> by making the freezer not send them fake signals.
> 
> Here live patching consistency model call klp_send_signals to wake up
> all tasks by send fake signal to all non-kthread which only check the
> PF_KTHREAD flag, so it still send signal to io threads which may lead to
> freezeing issue of io threads.
> 
> Here we take the same fix action by treating PF_IO_WORKERS as PF_KTHREAD
> within klp_send_signal function.
> 
> Signed-off-by: Dong Kai <dongkai11@huawei.com>
> ---
> note:
> the io threads freeze issue links:
> [1] https://lore.kernel.org/io-uring/YEgnIp43%2F6kFn8GL@kevinlocke.name/
> [2] https://lore.kernel.org/io-uring/d7350ce7-17dc-75d7-611b-27ebf2cb539b@kernel.dk/
> 
>   kernel/livepatch/transition.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> index f6310f848f34..0e1c35c8f4b4 100644
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
> @@ -358,7 +358,7 @@ static void klp_send_signals(void)
>   		 * Meanwhile the task could migrate itself and the action
>   		 * would be meaningless. It is not serious though.
>   		 */
> -		if (task->flags & PF_KTHREAD) {
> +		if (task->flags & (PF_KTHREAD | PF_IO_WORKER)) {
>   			/*
>   			 * Wake up a kthread which sleeps interruptedly and
>   			 * still has not been migrated.
> 

(PF_KTHREAD | PF_IO_WORKER) is open coded in soo many places maybe this 
is a silly question, but...

If the livepatch code could use fake_signal_wake_up(), we could 
consolidate the pattern in klp_send_signals() with the one in 
freeze_task().  Then there would only one place for wake up / fake 
signal logic.

I don't fully understand the differences in the freeze_task() version, 
so I only pose this as a question and not v2 request.

As it is, this change seems logical to me, so:
Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

Thanks,

-- Joe

