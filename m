Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5F635F781
	for <lists+live-patching@lfdr.de>; Wed, 14 Apr 2021 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhDNPVq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Apr 2021 11:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbhDNPVp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Apr 2021 11:21:45 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C82DC061574;
        Wed, 14 Apr 2021 08:21:24 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id e2so5988983plh.8;
        Wed, 14 Apr 2021 08:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LKBWpjyMDRFuuMYdGVnQkKgGtzVnoGLy1lYODPpAzN4=;
        b=Z7S2SFqo8Jhhfd7L9wAGEm2/Jq1XwM9BgNVD8/LS/YH5FFe3DS1y8X+8iIB5w1O//n
         7mOKIeUGvzKkAbJH7e4DroEhKLuKLt+2I8x0K8CT7vz2O9OjSzpA/hC6+oPbzvvs1egs
         IjOtQlRkE5W44ChjhY+CzpIQq5WIjo6mNKAEPSFwEc+U0ukXtCMxAeacQGrLwdjXFdP9
         9xBlsb8Axpzql02GqmTcTgCH8IrK7P6fCxrvlkxTKdtr5OWvg5Fhbe3cXaHhp6A/39Qt
         lM2DIxnnvrIDG1i0SoI+QxrMfGPcT6AzNI6p9nTIxQCWLzISJvksq4Ik/WQz3pm/KpZt
         koqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LKBWpjyMDRFuuMYdGVnQkKgGtzVnoGLy1lYODPpAzN4=;
        b=F+LcziuLA6i7exmS8CxNsFiVC8GZlB64Pngq/A5xfmjH35HXTMp6F4m7I8TIgmCDpn
         UPXqedv9dPVrHH5JYiNx6AQsGl9RGySJ7ZYQWRe9Vk6Q84IZ/FJha4PCJ+Nrpoz/2OYM
         1ZnfISlDesHT/jlWGxDkauYrvqvaIhpCtppXw5e9buR8ZxQjRm8pxBzUr/Ci+XjsdfP/
         pTM0M8OdKNWOKWegWr3Zxzxl8VJyWkQTJI84Wi3F+BotO/Gcd7lkzLym3rg2VFowBEeQ
         LU20JCqHFAjNEURUv04qfnC/cpQ+TJcdPwDV5xeuHliOVK3meoFcYblOcYR6M5iWG9iZ
         iELA==
X-Gm-Message-State: AOAM533m1fxNRSZmrJ9zK0Ku66pR7VEbBfGrJ+DOIwtPBKXUvJuWq/vC
        78jVgbb5iPXDEHrqKpfkHvE=
X-Google-Smtp-Source: ABdhPJwd4ONqa2AMY1ON0aLJIMUhue0FVe7zEZeVay8oBqQMWCiM781IfgmJxOymFSRRFgHbjnWRbw==
X-Received: by 2002:a17:902:b28b:b029:ea:eda0:4d5e with SMTP id u11-20020a170902b28bb02900eaeda04d5emr17850905plr.68.1618413683915;
        Wed, 14 Apr 2021 08:21:23 -0700 (PDT)
Received: from slime ([139.198.121.254])
        by smtp.gmail.com with ESMTPSA id y19sm17873854pge.50.2021.04.14.08.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:21:23 -0700 (PDT)
From:   xiaojun.zhao141@gmail.com
X-Google-Original-From: <xiaojunzhao141@gmail.com>
Date:   Wed, 14 Apr 2021 23:21:19 +0800
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     xiaojun.zhao141@gmail.com, josef@toxicpanda.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: the qemu-nbd process automatically exit with the commit
 43347d56c 'livepatch: send a fake signal to all blocking tasks'
Message-ID: <20210414232119.13b126fa@slime>
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
It occurs IO error of the nbd device when I use livepatch of the
nbd, and I guess that any livepatch on other kernel source maybe cause
the IO error. Well, now I decide to workaround for this problem by
adding a livepatch for the klp to disable a automatic fake signal.

Regards.

