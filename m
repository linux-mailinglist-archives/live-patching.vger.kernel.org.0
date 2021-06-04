Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2528739C186
	for <lists+live-patching@lfdr.de>; Fri,  4 Jun 2021 22:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhFDUq2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Jun 2021 16:46:28 -0400
Received: from linux.microsoft.com ([13.77.154.182]:43882 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFDUq2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Jun 2021 16:46:28 -0400
Received: from [192.168.254.32] (unknown [47.187.214.213])
        by linux.microsoft.com (Postfix) with ESMTPSA id B81E420B7178;
        Fri,  4 Jun 2021 13:44:40 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B81E420B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622839481;
        bh=TEj7EM3o5+98uJz07bRAjergvchDlGPCV6FJpuSvx4o=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=HouYNKoOc/HyfaQL1LCJbvsjnCx3jzuuAqk6uTacGwD253S95a3gu4rFYA4RAurVy
         7ZicmjTFGm48ks6edRn8/E2mK4FrqUfA2BmC8/oGFKkyk+8VZ6M3alaa9PvjEQcxyg
         vqo9nXtlvpetxo72bR+nFtDAIA1Xgm5aYcKeBA4c=
Subject: Re: [RFC PATCH v5 0/2] arm64: Implement stack trace reliability
 checks
To:     Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     jpoimboe@redhat.com, ardb@kernel.org, nobuta.keiya@fujitsu.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        pasha.tatashin@soleen.com, jthierry@redhat.com,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <ea0ef9ed6eb34618bcf468fbbf8bdba99e15df7d>
 <20210526214917.20099-1-madvenka@linux.microsoft.com>
 <20210604152908.GD4045@sirena.org.uk>
From:   "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <3e3fdff0-26ed-e786-e570-3f569bda1609@linux.microsoft.com>
Date:   Fri, 4 Jun 2021 15:44:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210604152908.GD4045@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Mark Rutland,

Could you please review this patch series when you get a chance?
I would really like to get a confirmation from you that there
are no gaps in this.

Thanks in advance!

Madhavan

On 6/4/21 10:29 AM, Mark Brown wrote:
> On Wed, May 26, 2021 at 04:49:15PM -0500, madvenka@linux.microsoft.com wrote:
>> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
>>
>> There are a number of places in kernel code where the stack trace is not
>> reliable. Enhance the unwinder to check for those cases and mark the
>> stack trace as unreliable. Once all of the checks are in place, the unwinder
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> 
