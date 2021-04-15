Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5CC360475
	for <lists+live-patching@lfdr.de>; Thu, 15 Apr 2021 10:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhDOIiL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Apr 2021 04:38:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:45596 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231736AbhDOIiI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Apr 2021 04:38:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 20484AE27;
        Thu, 15 Apr 2021 08:37:45 +0000 (UTC)
Date:   Thu, 15 Apr 2021 10:37:44 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
cc:     xiaojun.zhao141@gmail.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: the qemu-nbd process automatically exit with the commit 43347d56c
 'livepatch: send a fake signal to all blocking tasks'
In-Reply-To: <f7698105-23a4-4558-7b65-9116e8587848@toxicpanda.com>
Message-ID: <alpine.LSU.2.21.2104151026100.15642@pobox.suse.cz>
References: <20210414115548.0cdb529b@slime> <alpine.LSU.2.21.2104141320060.6604@pobox.suse.cz> <20210414232119.13b126fa@slime> <f7698105-23a4-4558-7b65-9116e8587848@toxicpanda.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 14 Apr 2021, Josef Bacik wrote:

> On 4/14/21 11:21 AM, xiaojun.zhao141@gmail.com wrote:
> > On Wed, 14 Apr 2021 13:27:43 +0200 (CEST)
> > Miroslav Benes <mbenes@suse.cz> wrote:
> > 
> >> Hi,
> >>
> >> On Wed, 14 Apr 2021, xiaojun.zhao141@gmail.com wrote:
> >>
> >>> I found the qemu-nbd process(started with qemu-nbd -t -c /dev/nbd0
> >>> nbd.qcow2) will automatically exit when I patched for functions of
> >>> the nbd with livepatch.
> >>>
> >>> The nbd relative source:
> >>> static int nbd_start_device_ioctl(struct nbd_device *nbd, struct
> >>> block_device *bdev)
> >>> { struct nbd_config *config =
> >>> nbd->config; int
> >>> ret;
> >>>          ret =
> >>> nbd_start_device(nbd); if
> >>> (ret) return
> >>> ret;
> >>>          if
> >>> (max_part) bdev->bd_invalidated =
> >>> 1;
> >>> mutex_unlock(&nbd->config_lock); ret =
> >>> wait_event_interruptible(config->recv_wq,
> >>> atomic_read(&config->recv_threads) == 0); if
> >>> (ret)
> >>> sock_shutdown(nbd);
> >>> flush_workqueue(nbd->recv_workq);
> >>>          mutex_lock(&nbd->config_lock);
> >>>          nbd_bdev_reset(bdev);
> >>>          /* user requested, ignore socket errors
> >>> */ if (test_bit(NBD_RT_DISCONNECT_REQUESTED,
> >>> &config->runtime_flags)) ret =
> >>> 0; if (test_bit(NBD_RT_TIMEDOUT,
> >>> &config->runtime_flags)) ret =
> >>> -ETIMEDOUT; return
> >>> ret; }
> >>
> >> So my understanding is that ndb spawns a number
> >> (config->recv_threads) of workqueue jobs and then waits for them to
> >> finish. It waits interruptedly. Now, any signal would make
> >> wait_event_interruptible() to return -ERESTARTSYS. Livepatch fake
> >> signal is no exception there. The error is then propagated back to
> >> the userspace. Unless a user requested a disconnection or there is
> >> timeout set. How does the userspace then reacts to it? Is
> >> _interruptible there because the userspace sends a signal in case of
> >> NBD_RT_DISCONNECT_REQUESTED set? How does the userspace handles
> >> ordinary signals? This all sounds a bit strange, but I may be missing
> >> something easily.
> >>
> >>> When the nbd waits for atomic_read(&config->recv_threads) == 0, the
> >>> klp will send a fake signal to it then the qemu-nbd process exits.
> >>> And the signal of sysfs to control this action was removed in the
> >>> commit 10b3d52790e 'livepatch: Remove signal sysfs attribute'. Are
> >>> there other ways to control this action? How?
> >>
> >> No, there is no way currently. We send a fake signal automatically.
> >>
> >> Regards
> >> Miroslav
> > It occurs IO error of the nbd device when I use livepatch of the
> > nbd, and I guess that any livepatch on other kernel source maybe cause
> > the IO error. Well, now I decide to workaround for this problem by
> > adding a livepatch for the klp to disable a automatic fake signal.
> > 
> 
> Would wait_event_killable() fix this problem?  I'm not sure any client
> implementations depend on being able to send other signals to the client
> process, so it should be safe from that standpoint.  Not sure if the livepatch
> thing would still get an error at that point tho.  Thanks,

wait_event_killable() means that you would sleep uninterruptedly (still 
reacting to fatal signals), so the fake signal from livepatch would not be 
sent at all. set_notify_signal() handles TASK_INTERRUPTIBLE tasks. No 
disruption for the userspace and it would fix this problem.

There is a catch on the livepatch side of things. If there is a live patch 
for nbd_start_device_ioctl(), the transition process would get stuck until 
the task leaves the function (all workqueue jobs are processed). I gather 
it is unlikely to be it indefinite, so we can live with that, I think.

Miroslav
