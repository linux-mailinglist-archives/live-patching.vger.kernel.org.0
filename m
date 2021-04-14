Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E3C35F264
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 13:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241695AbhDNL2G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 07:28:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:52102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232069AbhDNL2G (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 07:28:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2713EAFE1;
        Wed, 14 Apr 2021 11:27:44 +0000 (UTC)
Date:   Wed, 14 Apr 2021 13:27:43 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     xiaojun.zhao141@gmail.com
cc:     josef@toxicpanda.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: the qemu-nbd process automatically exit with the commit 43347d56c
 'livepatch: send a fake signal to all blocking tasks'
In-Reply-To: <20210414115548.0cdb529b@slime>
Message-ID: <alpine.LSU.2.21.2104141320060.6604@pobox.suse.cz>
References: <20210414115548.0cdb529b@slime>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Wed, 14 Apr 2021, xiaojun.zhao141@gmail.com wrote:

> I found the qemu-nbd process(started with qemu-nbd -t -c /dev/nbd0
> nbd.qcow2) will automatically exit when I patched for functions of
> the nbd with livepatch.
> 
> The nbd relative source:
> static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *bdev)
> {                                                                               
>         struct nbd_config *config = nbd->config;                                
>         int ret;                                                                
>                                                                                 
>         ret = nbd_start_device(nbd);                                            
>         if (ret)                                                                
>                 return ret;                                                     
>                                                                                 
>         if (max_part)                                                           
>                 bdev->bd_invalidated = 1;                                       
>         mutex_unlock(&nbd->config_lock);                                        
>         ret = wait_event_interruptible(config->recv_wq,                         
>                                          atomic_read(&config->recv_threads) == 0);
>         if (ret)                                                                
>                 sock_shutdown(nbd);                                             
>         flush_workqueue(nbd->recv_workq);                                       
>                                                                                 
>         mutex_lock(&nbd->config_lock);                                          
>         nbd_bdev_reset(bdev);                                                   
>         /* user requested, ignore socket errors */                              
>         if (test_bit(NBD_RT_DISCONNECT_REQUESTED, &config->runtime_flags))      
>                 ret = 0;                                                        
>         if (test_bit(NBD_RT_TIMEDOUT, &config->runtime_flags))                  
>                 ret = -ETIMEDOUT;                                               
>         return ret;                                                             
> }

So my understanding is that ndb spawns a number (config->recv_threads) of 
workqueue jobs and then waits for them to finish. It waits interruptedly. 
Now, any signal would make wait_event_interruptible() to return 
-ERESTARTSYS. Livepatch fake signal is no exception there. The error is 
then propagated back to the userspace. Unless a user requested a 
disconnection or there is timeout set. How does the userspace then reacts 
to it? Is _interruptible there because the userspace sends a signal in 
case of NBD_RT_DISCONNECT_REQUESTED set? How does the userspace handles 
ordinary signals? This all sounds a bit strange, but I may be missing 
something easily.

> When the nbd waits for atomic_read(&config->recv_threads) == 0, the klp
> will send a fake signal to it then the qemu-nbd process exits. And the
> signal of sysfs to control this action was removed in the commit
> 10b3d52790e 'livepatch: Remove signal sysfs attribute'. Are there other
> ways to control this action? How?

No, there is no way currently. We send a fake signal automatically.

Regards
Miroslav
