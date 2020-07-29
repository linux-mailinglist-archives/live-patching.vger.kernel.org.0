Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95A562322A3
	for <lists+live-patching@lfdr.de>; Wed, 29 Jul 2020 18:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgG2QYp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Jul 2020 12:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbgG2QYo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Jul 2020 12:24:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0585B2082E;
        Wed, 29 Jul 2020 16:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596039884;
        bh=KPOw/lKcFVoDkvC8+DqkXfmOUiLFkBinFYc+24JFOno=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gzMKH05D2YSHRkEPkjJwt4+2U4+Jb62ODbX8FpG/tlNcNVuwjQz8PZWrlOD262iKN
         1STJhKF5ElKhbRwiEq5CSW/VNSyG5ZvgrSTiWPcnmMuYCBmu1jvt14Cw9DrEy7FyjQ
         HcAJgUWpbxT2mOiNboLnZUaKlLN440POoEfDE+XM=
Date:   Wed, 29 Jul 2020 18:24:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        open list <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 2/7] modules: mark find_symbol static
Message-ID: <20200729162435.GB3664300@kroah.com>
References: <20200729062711.13016-1-hch@lst.de>
 <20200729062711.13016-3-hch@lst.de>
 <20200729161318.GA30898@linux-8ccs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200729161318.GA30898@linux-8ccs>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 29, 2020 at 06:13:18PM +0200, Jessica Yu wrote:
> +++ Christoph Hellwig [29/07/20 08:27 +0200]:
> > find_symbol is only used in module.c.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> CCing the livepatching ML, as this may or may not impact its users.
> 
> AFAIK, the out-of-tree kpatch module had used find_symbol() in the
> past, I am not sure what its current status is. I suspect all of its
> functionality has been migrated to upstream livepatch already.

We still have symbol_get(), which is what I thought they were using.

If only we could get rid of that export one day...

thanks,

greg k-h
