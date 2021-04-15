Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B74B360259
	for <lists+live-patching@lfdr.de>; Thu, 15 Apr 2021 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhDOG1r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Apr 2021 02:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhDOG1r (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Apr 2021 02:27:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2A6EC061574;
        Wed, 14 Apr 2021 23:27:24 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w8so11912172pfn.9;
        Wed, 14 Apr 2021 23:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aFP176e6SDQYmkgg1H2hgNgk/y6S10MJQ0cQWx4VO98=;
        b=AlgnJ6O6Z9zvWPMgjtcMQXDFmtXFcBEMlheyX6HvqhT/11CZxQnp8na03VaXdBBUCG
         gU9WIuJqmU2rYsWk4UP2gpp4NEWjksTehNLxP3OOZabjwGIeJDPJyTS3jswGeiDLlRGO
         2lKGBZupmo85sZy5+zUh040W3Y+M2mDpw+ziu6Q19yirp3N04VO995GUKU7Ipqi5trPy
         rZodUlKd9HWMsewv4FXYdaV2GlTXfaV8UgaXXUy2eZKKOy691xDfP2XjNy/cDnFlef/w
         Z1SoA78SJ4y2IDrRZ9kMm9RIdBANVlGGDV4FANs1Ogp7SoAqLeRL1lpyCuwVPNwkQWwR
         nM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aFP176e6SDQYmkgg1H2hgNgk/y6S10MJQ0cQWx4VO98=;
        b=SVD0TLqgXT53IkC6zLcO5Edq0+wXBS3FYAEXq2jYyrbNwA4AdMHI+HDRCaAndOpj5X
         5bxdHUPszrCvc0H34xGutWPLwLUbKbwaQdN1qxiJs6EXonNC6VHcP4LS1/Tk4L5BLG5p
         aKMCtFYVjPbqSxNrb4WJulfS5fnarr9TbuLvfPuv3bMqvpEMHnH9y0ipXHyiBgEc6f/s
         TsYi/n55YtX+3D+TfBQbeg2maybHRkSzduNIpQC3mVxT9+/HXedhOSLK8pHq7hqP6yyD
         KL1iobB5svw+4aBVp82CiaJXF3+aQx2D7RFH6X//9r836KowOytP4hY6Ekw9/ocZBo7M
         ldKQ==
X-Gm-Message-State: AOAM530G/jKQHBjIZk8kIGcZk1LG4tb3BqMg3NEXWl5LOcMNPWFwYoiI
        sk+7mI7BXMHPGil5ZJIKedDw/rs2aOI=
X-Google-Smtp-Source: ABdhPJyl67qxXUVPY0Zl73EACjHAxhAEUKdQVO5mb+aOSdvPNLGhlP0UGGxFjvBxIVY0YEK0psoGmQ==
X-Received: by 2002:a05:6a00:148e:b029:250:5556:c7b3 with SMTP id v14-20020a056a00148eb02902505556c7b3mr1604576pfu.77.1618468044360;
        Wed, 14 Apr 2021 23:27:24 -0700 (PDT)
Received: from slime ([139.198.121.254])
        by smtp.gmail.com with ESMTPSA id 18sm1112953pfu.190.2021.04.14.23.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 23:27:24 -0700 (PDT)
From:   xiaojun.zhao141@gmail.com
X-Google-Original-From: <xiaojunzhao141@gmail.com>
Date:   Thu, 15 Apr 2021 14:27:20 +0800
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     xiaojun.zhao141@gmail.com, Miroslav Benes <mbenes@suse.cz>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: the qemu-nbd process automatically exit with the commit
 43347d56c 'livepatch: send a fake signal to all blocking tasks'
Message-ID: <20210415142720.7bebde2a@slime>
In-Reply-To: <f7698105-23a4-4558-7b65-9116e8587848@toxicpanda.com>
References: <20210414115548.0cdb529b@slime>
 <alpine.LSU.2.21.2104141320060.6604@pobox.suse.cz>
 <20210414232119.13b126fa@slime>
 <f7698105-23a4-4558-7b65-9116e8587848@toxicpanda.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 14 Apr 2021 13:21:37 -0400
Josef Bacik <josef@toxicpanda.com> wrote:

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
> >> _interruptible there because the userspace sends a signal in case
> >> of NBD_RT_DISCONNECT_REQUESTED set? How does the userspace handles
> >> ordinary signals? This all sounds a bit strange, but I may be
> >> missing something easily.
> >>  
> >>> When the nbd waits for atomic_read(&config->recv_threads) == 0,
> >>> the klp will send a fake signal to it then the qemu-nbd process
> >>> exits. And the signal of sysfs to control this action was removed
> >>> in the commit 10b3d52790e 'livepatch: Remove signal sysfs
> >>> attribute'. Are there other ways to control this action? How?  
> >>
> >> No, there is no way currently. We send a fake signal automatically.
> >>
> >> Regards
> >> Miroslav  
> > It occurs IO error of the nbd device when I use livepatch of the
> > nbd, and I guess that any livepatch on other kernel source maybe
> > cause the IO error. Well, now I decide to workaround for this
> > problem by adding a livepatch for the klp to disable a automatic
> > fake signal. 
> 
> Would wait_event_killable() fix this problem?  I'm not sure any
> client implementations depend on being able to send other signals to
> the client process, so it should be safe from that standpoint.  Not
> sure if the livepatch thing would still get an error at that point
> tho.  Thanks,
> Josef
Yes, I tested that wait_event_killable() can fix this problem.

Thanks.

