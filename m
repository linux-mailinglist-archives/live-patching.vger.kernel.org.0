Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAE7835F6E3
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 16:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231834AbhDNOyv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 10:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349698AbhDNOyW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 10:54:22 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2370BC06135F;
        Wed, 14 Apr 2021 07:52:34 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id nm3-20020a17090b19c3b029014e1bbf6c60so6777889pjb.4;
        Wed, 14 Apr 2021 07:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4XkoYmFRvVingy29s62AE9pk1GqT7aCUqM2F6T8eWVM=;
        b=DyzuIz36gghGh4Pb3zLXl9BcGYmCU8qvrO4YeLUK28ps26SIYJpJsPTAy41zxtetxQ
         5+W1/6kjnMpXSTZbe8NWTLWTv3v5hkfGPvcJclPuTcSMKiMm61BSUQOzlQgtkVjHEGEz
         QFz1qefcFcd4qzw8IvJJeGfSyqy4jt/R4vo/W51ByR380cyRXUOEWAplygfaJFIwyhcg
         +OJlJ3OEEI/LVu5SeteTtt0kfLDgKjEL7iz6Ut2Yrx+AB0TFIrIofTZ0McKL8V+7Ufcz
         H4pwouzMEbU4docKvhHRe9syXcZCAk1GRMo45tWmLLE2oZ61Q0VuC5B5Rpr8vjNVP+tV
         fd3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4XkoYmFRvVingy29s62AE9pk1GqT7aCUqM2F6T8eWVM=;
        b=BRHmSComEwj292g5CX5pFAu0q/KAE6mNbWlIjupcsSRBp9MOcbtwA+CwuvK6FFV8hO
         I8VrVmXUY1oa75rJpAIq8hfH5AUpqQ9WypfI8/P3FA813gkUo1GthdjdCGZSZCkKBg0M
         nbkDcUeMQWa59f4w18EfD+ljzONjviFYLXm2eNPkWFIH2SwjePXHHIh+25ohqaMsKDTp
         OQG4mBvKjMfRUq8sA7l7C9EuBl4qyqhEYhSWadIfoPoEc6eFmGCgGB9T8reWLY1DAfWi
         D8auM1TAGZwTVUW5+W1rCQriBz5eE/SkAlD9UNmMtxBIr8eKZwVjybrlvLIfQoYq7el3
         IdEA==
X-Gm-Message-State: AOAM533JUmy9mD1uZXHpsPkLBVqBPtoU19YUSU+y4b+Y3ayktuF2opsG
        8NvfDjzarQsE/+svT9dQwmg=
X-Google-Smtp-Source: ABdhPJxLe4e3ArNLjIvLa46OtcJYqVPrwLT/5Pq8idpyDrx0xtUMIBXQOG/IjgfkpMbzcIBVAJl8/A==
X-Received: by 2002:a17:90a:fb89:: with SMTP id cp9mr3959882pjb.47.1618411953609;
        Wed, 14 Apr 2021 07:52:33 -0700 (PDT)
Received: from slime ([139.198.121.254])
        by smtp.gmail.com with ESMTPSA id e13sm7639837pfd.64.2021.04.14.07.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 07:52:33 -0700 (PDT)
From:   xiaojun.zhao141@gmail.com
X-Google-Original-From: <xiaojunzhao141@gmail.com>
Date:   Wed, 14 Apr 2021 22:52:28 +0800
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     xiaojun.zhao141@gmail.com, josef@toxicpanda.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: the qemu-nbd process automatically exit with the commit
 43347d56c 'livepatch: send a fake signal to all blocking tasks'
Message-ID: <20210414225228.436ae00d@slime>
In-Reply-To: <alpine.LSU.2.21.2104141320060.6604@pobox.suse.cz>
References: <20210414115548.0cdb529b@slime>
        <alpine.LSU.2.21.2104141320060.6604@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 14 Apr 2021 13:27:43 +0200 (CEST)
Miroslav Benes <mbenes@suse.cz> wrote:

> Hi,
> 
> On Wed, 14 Apr 2021, xiaojun.zhao141@gmail.com wrote:
> 
> > I found the qemu-nbd process(started with qemu-nbd -t -c /dev/nbd0
> > nbd.qcow2) will automatically exit when I patched for functions of
> > the nbd with livepatch.
> > 
> > The nbd relative source:
> > static int nbd_start_device_ioctl(struct nbd_device *nbd, struct
> > block_device *bdev)
> > { struct nbd_config *config =
> > nbd->config; int
> > ret; 
> >         ret =
> > nbd_start_device(nbd); if
> > (ret) return
> > ret; 
> >         if
> > (max_part) bdev->bd_invalidated =
> > 1;
> > mutex_unlock(&nbd->config_lock); ret =
> > wait_event_interruptible(config->recv_wq,
> > atomic_read(&config->recv_threads) == 0); if
> > (ret)
> > sock_shutdown(nbd);
> > flush_workqueue(nbd->recv_workq); 
> >         mutex_lock(&nbd->config_lock);                                          
> >         nbd_bdev_reset(bdev);                                                   
> >         /* user requested, ignore socket errors
> > */ if (test_bit(NBD_RT_DISCONNECT_REQUESTED,
> > &config->runtime_flags)) ret =
> > 0; if (test_bit(NBD_RT_TIMEDOUT,
> > &config->runtime_flags)) ret =
> > -ETIMEDOUT; return
> > ret; }  
> 
> So my understanding is that ndb spawns a number
> (config->recv_threads) of workqueue jobs and then waits for them to
> finish. It waits interruptedly. Now, any signal would make
> wait_event_interruptible() to return -ERESTARTSYS. Livepatch fake
> signal is no exception there. The error is then propagated back to
> the userspace. Unless a user requested a disconnection or there is
> timeout set. How does the userspace then reacts to it? Is
> _interruptible there because the userspace sends a signal in case of
> NBD_RT_DISCONNECT_REQUESTED set? How does the userspace handles
> ordinary signals? This all sounds a bit strange, but I may be missing
> something easily.
>
Sorry, now I also don't know how the qemu-nbd handles these signals. I
need to see its source.

Thank you very much. 
> > When the nbd waits for atomic_read(&config->recv_threads) == 0, the
> > klp will send a fake signal to it then the qemu-nbd process exits.
> > And the signal of sysfs to control this action was removed in the
> > commit 10b3d52790e 'livepatch: Remove signal sysfs attribute'. Are
> > there other ways to control this action? How?  
> 
> No, there is no way currently. We send a fake signal automatically.
> 
> Regards
> Miroslav

